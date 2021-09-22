import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:http/http.dart' as http;
import 'package:yakuswap/repositories/constants.dart';

class EthRepository {
  String? address;
  Web3Provider? provider;

  String? getAddress() {
    return address;
  }

  Future<void> connectWallet() async {
    try {
      final accs = await ethereum!.requestAccount();
      address = accs.first;
    } on EthereumUserRejected {
      address = null;
    }
  }

  Future<void> registerListener() async {
    ethereum!.removeAllListeners();
    ethereum!.onAccountsChanged((accounts) {
      address = accounts.first;
    });
  }

  Future<void> _updateData(String tradeId, Map<String, dynamic> data) async {
    await http.post(
      Uri.parse("$API_HOST/eth/trade/$tradeId"),
      body: jsonEncode({"data": Map<String, dynamic>.from(data)}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<String?> _getSwapHash(Contract contract, Map<String, dynamic> args) async {
    final filter = contract.getFilter('SwapCreated', [null, args['token_address'], args['from_address'], args['to_address']]);
    final events = await contract.queryFilter(filter, -257);

    Event? event;
    for(int i = 0; i < events.length; ++i) {
      String sHash = events[i].args[5];
      if(sHash.replaceFirst("0x", "") == args['secret_hash']) {
        event = events[i];
        break;
      }
    }

    if(event == null) return null;

    final String swapHash1 = event.args[0].replaceFirst("0x", "");
    final int blockNumber = int.parse(event.args[6].toString());

    final String swapHash2 = await contract.call('getSwapHash', 
      [args['token_address'], args['from_address'], args['to_address'], BigInt.from(args['amount'] * 1000000000).toBigNumber, hex.decode(args['secret_hash']), blockNumber]
    );

    if(swapHash1 != swapHash2.replaceFirst("0x", "")) return null;
    return swapHash1;
  }

  Future<int> _getSwapBlockNumber(Contract contract, Map<String, dynamic> args) async {
    final filter = contract.getFilter('SwapCreated', [null, args['token_address'], args['from_address'], args['to_address']]);
    final events = await contract.queryFilter(filter, -257);

    Event? event;
    for(int i = 0; i < events.length; ++i) {
      String sHash = events[i].args[5];
      if(sHash.replaceFirst("0x", "") == args['secret_hash']) {
        event = events[i];
        break;
      }
    }

    final int blockNumber = int.parse(event!.args[6].toString());

    return blockNumber;
  }

  Future<bool> createSwap(String tradeId, Map<String, dynamic> args, Function(String)? showMessage) async {
    final String contractAddress = args["contract_address"]!;
    final String tokenAddress = args["token_address"]!;
    final String fromAddress = args["from_address"]!;
    final BigInt amount = BigInt.from(args['amount'] * 1000000000);
    provider ??= Web3Provider(ethereum!);

    final Contract contract = Contract(
      contractAddress,
      Interface(ETH_CONTRACT_ABI),
      provider!.getSigner(),
    );
    final ContractERC20 tokenContract = ContractERC20(
      tokenAddress,
      provider!.getSigner(),
    );

    final String? swapHash = await _getSwapHash(contract, args);

    if(swapHash == null) {
      final BigInt approvedAmount = await tokenContract.allowance(fromAddress, contractAddress);
      if(approvedAmount < amount) {
        try {
          final TransactionResponse tx1 = await tokenContract.approve(contractAddress, amount);
          await _updateData(tradeId, {"token_approval_tx_sent": true});
          await tx1.wait(1);
          await _updateData(tradeId, {"token_approval_tx_confirmed": true});
        } catch(_) {
          if(showMessage != null) showMessage("Transaction rejected :(");
          return false;
        }
      } else {
        await _updateData(tradeId, {"token_approval_tx_sent": true, "token_approval_tx_confirmed": true});
      }
    
      TransactionResponse tx2;
      try {
        tx2 = await contract.send(
          'createSwap',
          [tokenAddress, args['to_address'], amount.toBigNumber, hex.decode(args['secret_hash'])],
        );
      } catch(_) {
        if(showMessage != null) showMessage("Transaction rejected :(");
        return false;
      }

      if(showMessage != null) showMessage("Transaction sent; waiting for confirmation...");
      await _updateData(tradeId, {"createSwap_tx_sent": true});
    
      await tx2.wait(1);
    } else {
      await _updateData(tradeId, {"token_approval_tx_sent": true, "token_approval_tx_confirmed": true});
      await _updateData(tradeId, {"createSwap_tx_sent": true});
    }

    await _updateData(tradeId, {"swap_created": true});

    return true;
  }

  Stream<void> waitForSwap(String tradeId, Map<String, dynamic> args, Function(String)? showMessage) async* {
    final String contractAddress = args["contract_address"]!;
    provider ??= Web3Provider(ethereum!);

    final Contract contract = Contract(
      contractAddress,
      Interface(ETH_CONTRACT_ABI),
      provider!.getSigner(),
    );

    String? swapHash = await _getSwapHash(contract, args);

    while(swapHash == null) {
      swapHash = await _getSwapHash(contract, args);
      await Future.delayed(const Duration(seconds: 5));
    }

    final int swap = await contract.call('swaps', [hex.decode(swapHash)]);
    if(swap != 1) {
      if(showMessage != null) showMessage("Swap status is wrong - cancelling trade");
      await _updateData(tradeId, {"swap_id": swapHash, "confirmations": -1, "should_cancel": true});
      return;
    }
    
    final int swapBlockNumber = await _getSwapBlockNumber(contract, args);
    BigInt blockNumber;

    while(true) {
      blockNumber = await ethereum!.request<BigInt>('eth_blockNumber');
      await _updateData(tradeId, {
        "swap_id": swapHash,
        "confirmations": blockNumber.toInt() - swapBlockNumber,
          "should_cancel": false
      });
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  Future<bool> completeSwap(String tradeId, Map<String, dynamic> args, Function(String)? showMessage) async {
    final String contractAddress = args["contract_address"]!;
    final BigInt amount = BigInt.from(args['amount'] * 1000000000);

    provider ??= Web3Provider(ethereum!);

    final Contract contract = Contract(
      contractAddress,
      Interface(ETH_CONTRACT_ABI),
      provider!.getSigner(),
    );

    final int blockNumber = await _getSwapBlockNumber(contract, args);

    TransactionResponse tx;
    try {
      tx = await contract.send(
        'completeSwap',
        [args['token_address'], args['from_address'], args['to_address'], amount.toBigNumber, blockNumber, args['secret']],
      );
    } catch(_) {
      if(showMessage != null) showMessage("Transaction rejected :(");
      return false;
    }

    if(showMessage != null) showMessage("Transaction sent; waiting for confirmation...");
    await tx.wait(1);

    await _updateData(tradeId, {"swap_completed": true});

    return true;
  }

  Future<bool> cancelSwap(String tradeId, Map<String, dynamic> args, Function(String)? showMessage) async {
    final String contractAddress = args["contract_address"]!;
    final BigInt amount = BigInt.from(args['amount'] * 1000000000);
    provider ??= Web3Provider(ethereum!);

    final Contract contract = Contract(
      contractAddress,
      Interface(ETH_CONTRACT_ABI),
      provider!.getSigner(),
    );

    final int blockNumber = await _getSwapBlockNumber(contract, args);

    TransactionResponse tx;
    try {
      tx = await contract.send(
        'cancelSwap',
        [args['token_address'], args['to_address'], amount.toBigNumber, hex.decode(args['secret_hash']), blockNumber]
      );
    } catch(_) {
      if(showMessage != null) showMessage("Transaction rejected :(");
      return false;
    }

    if(showMessage != null) showMessage("Transaction sent; waiting for confirmation...");
    await tx.wait(1);

    await _updateData(tradeId, {"swap_completed": true});

    return true;
  }
}