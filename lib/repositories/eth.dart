import 'package:flutter_web3/flutter_web3.dart';

class EthRepository {
  String? address;

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
}