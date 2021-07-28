import 'package:equatable/equatable.dart';
import 'package:yakuswap/models/trade_currency.dart';

class Trade extends Equatable {
  final String id;
  final TradeCurrency tradeCurrencyOne;
  final TradeCurrency tradeCurrencyTwo;
  final String secretHash;
  final bool isBuyer;
  final String? secret;
  final int step;

  Trade({
    required this.id,
    required this.tradeCurrencyOne,
    required this.tradeCurrencyTwo,
    required this.secretHash,
    required this.isBuyer,
    required this.secret,
    required this.step
  });

  Trade.fromJSON(Map<String, dynamic> data) :
    this.id = data['id'],
    this.tradeCurrencyOne = TradeCurrency.fromJSON(data['trade_currency_one']),
    this.tradeCurrencyTwo = TradeCurrency.fromJSON(data['trade_currency_two']),
    this.secretHash = data['secret_hash'],
    this.isBuyer = data['is_buyer'],
    this.secret = data['secret'],
    this.step = data['step'];

  Map<String, dynamic> toJSON() => {
    'id': this.id,
    'trade_currency_one': this.tradeCurrencyOne.toJSON(),
    'trade_currency_two': this.tradeCurrencyTwo.toJSON(),
    'secret_hash': this.secretHash,
    'is_buyer': this.isBuyer,
    'secret': this.secret,
    'step': this.step,
  };

  Map<String, dynamic> toSafeJSON() => {
    'id': this.id,
    'trade_currency_one': this.tradeCurrencyOne.toJSON(),
    'trade_currency_two': this.tradeCurrencyTwo.toJSON(),
    'secret_hash': this.secretHash,
    'is_buyer': !this.isBuyer,
    'secret': null,
    'step': 0,
  };

  @override
  List<Object?> get props => [id, tradeCurrencyOne, tradeCurrencyTwo, secretHash, isBuyer, secret, step];
}