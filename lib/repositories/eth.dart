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

  Future<bool> createSwap(String tradeId, Map<String, dynamic> args, Function(String)? showMessage) async {
    final String contractAddress = args["contract_address"]!;
    provider ??= Web3Provider(ethereum!);

    final Contract contract = Contract(
      contractAddress,
      Interface(ETH_CONTRACT_ABI),
      provider!.getSigner(),
    );

    final String swapId = await contract.call<String>('getSwapId', [hex.decode(args['secret_hash']), args['from_address']]);
    final swap = await contract.call('swaps', [hex.decode(swapId.replaceFirst("0x", ""))]);

    if(swap[0] != 0) {
      if(showMessage != null) showMessage("Previous swap found");
    } else {
      TransactionResponse tx;
      try {
        tx = await contract.send(
          'createSwap',
          [hex.decode(args['secret_hash']), args['to_address'], args['max_block_height']],
          TransactionOverride(value: BigInt.from(args['amount'] * 1000000000)),
        );
      } catch(_) {
        if(showMessage != null) showMessage("Transaction rejected :(");
        return false;
      }

      if(showMessage != null) showMessage("Transaction sent; waiting for confirmation...");
      await tx.wait(1);
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

    final String swapId = (await contract.call<String>('getSwapId', [hex.decode(args['secret_hash']), args['from_address']])).replaceFirst("0x", "");
    dynamic swap = await contract.call('swaps', [hex.decode(swapId)]);

    while(swap == null || swap[0] == 0) {
      swap = await contract.call('swaps', [hex.decode(swapId)]);
      await Future.delayed(const Duration(seconds: 5));
    }

    // 1000000000 * 993 / 1000 = 1000000 * 993 = 993000000 (amount after 0.7% fee)
    if(swap[0] != 1 ||
        int.parse(swap[2].toString()) < args['amount'] * 993000000 ||
        swap[3] != "0x" + args['secret_hash'] ||
        swap[5].toLowerCase() != args['to_address'].toLowerCase() ||
        swap[6] != 256) {
      if(showMessage != null) showMessage("Swap parameters are wrong - cancelling trade");
      await _updateData(tradeId, {"swap_id": swapId, "confirmations": -1, "should_cancel": true});
      return;
    }
    BigInt blockNumber = await ethereum!.request<BigInt>('eth_blockNumber');
    swap = await contract.call('swaps', [hex.decode(swapId)]);

    while(true) {
      if(swap != null && swap[0] != 0) {
        await _updateData(tradeId, {
          "swap_id": swapId,
          "confirmations": blockNumber.toInt() - int.parse(swap[1].toString()),
          "should_cancel": false});
      }
      await Future.delayed(const Duration(seconds: 5));
      blockNumber = await ethereum!.request<BigInt>('eth_blockNumber');
      swap = await contract.call('swaps', [hex.decode(swapId)]);
    }
  }

  Future<bool> completeSwap(String tradeId, Map<String, dynamic> args, Function(String)? showMessage) async {
    final String contractAddress = args["contract_address"]!;
    provider ??= Web3Provider(ethereum!);

    final Contract contract = Contract(
      contractAddress,
      Interface(ETH_CONTRACT_ABI),
      provider!.getSigner(),
    );

    TransactionResponse tx;
    try {
      tx = await contract.send(
        'completeSwap',
        [hex.decode(args['swap_id']), args['secret']],
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
    provider ??= Web3Provider(ethereum!);

    final Contract contract = Contract(
      contractAddress,
      Interface(ETH_CONTRACT_ABI),
      provider!.getSigner(),
    );

    TransactionResponse tx;
    try {
      tx = await contract.send(
        'cancelSwap',
        [hex.decode(args['swap_id'])],
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