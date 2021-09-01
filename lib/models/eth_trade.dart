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

  EthTrade({
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
    this.id = data['id'],
    this.tradeCurrency = TradeCurrency.fromJSON(data['trade_currency']),
    this.ethFromAddress = data['eth_from_address'],
    this.ethToAddress = data['eth_to_address'],
    this.totalWei = data['total_wei'],
    this.secretHash = data['secret_hash'],
    this.isBuyer = data['is_buyer'],
    this.secret = data['secret'],
    this.step = data['step'];

  Map<String, dynamic> toJSON() => {
    'id': this.id,
    'trade_currency': this.tradeCurrency.toJSON(),
    'eth_from_address': this.ethFromAddress,
    'eth_to_address': this.ethToAddress,
    'total_wei': this.totalWei,
    'secret_hash': this.secretHash,
    'is_buyer': this.isBuyer,
    'secret': this.secret,
    'step': this.step,
  };

  Map<String, dynamic> toSafeJSON() => {
    'id': this.id,
    'trade_currency': this.tradeCurrency.toJSON(),
    'eth_from_address': this.ethFromAddress,
    'eth_to_address': this.ethToAddress,
    'total_wei': this.totalWei,
    'secret_hash': this.secretHash,
    'is_buyer': !this.isBuyer,
    'secret': null,
    'step': 0,
  };

  @override
  List<Object?> get props => [id, tradeCurrency, ethFromAddress, ethToAddress, totalWei, secretHash, isBuyer, secret, step];
}