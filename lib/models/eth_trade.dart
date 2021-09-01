import 'package:equatable/equatable.dart';
import 'package:yakuswap/models/trade_currency.dart';

class EthTrade extends Equatable {
  final String id;
  final TradeCurrency tradeCurrency;
  final String ethFromAddress;
  final String ethToAddress;
  final int totalWei;
  final String secretHash;
  final bool isBuyer;
  final String? secret;
  final int step;

  const EthTrade({
    required this.id,
    required this.tradeCurrency,
    required this.ethFromAddress,
    required this.ethToAddress,
    required this.totalWei,
    required this.secretHash,
    required this.isBuyer,
    required this.secret,
    required this.step
  });

  EthTrade.fromJSON(Map<String, dynamic> data) :
    id = data['id'],
    tradeCurrency = TradeCurrency.fromJSON(data['trade_currency']),
    ethFromAddress = data['eth_from_address'],
    ethToAddress = data['eth_to_address'],
    totalWei = data['total_wei'],
    secretHash = data['secret_hash'],
    isBuyer = data['is_buyer'],
    secret = data['secret'],
    step = data['step'];

  Map<String, dynamic> toJSON() => {
    'id': id,
    'trade_currency': tradeCurrency.toJSON(),
    'eth_from_address': ethFromAddress,
    'eth_to_address': ethToAddress,
    'total_wei': totalWei,
    'secret_hash': secretHash,
    'is_buyer': isBuyer,
    'secret': secret,
    'step': step,
  };

  Map<String, dynamic> toSafeJSON() => {
    'id': id,
    'trade_currency': tradeCurrency.toJSON(),
    'eth_from_address': ethFromAddress,
    'eth_to_address': ethToAddress,
    'total_wei': totalWei,
    'secret_hash': secretHash,
    'is_buyer': !isBuyer,
    'secret': null,
    'step': 0,
  };

  @override
  List<Object?> get props => [id, tradeCurrency, ethFromAddress, ethToAddress, totalWei, secretHash, isBuyer, secret, step];
}