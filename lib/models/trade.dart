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

  const Trade({
    required this.id,
    required this.tradeCurrencyOne,
    required this.tradeCurrencyTwo,
    required this.secretHash,
    required this.isBuyer,
    required this.secret,
    required this.step
  });

  Trade.fromJSON(Map<String, dynamic> data) :
    id = data['id'],
    tradeCurrencyOne = TradeCurrency.fromJSON(data['trade_currency_one']),
    tradeCurrencyTwo = TradeCurrency.fromJSON(data['trade_currency_two']),
    secretHash = data['secret_hash'],
    isBuyer = data['is_buyer'],
    secret = data['secret'],
    step = data['step'];

  Map<String, dynamic> toJSON() => {
    'id': id,
    'trade_currency_one': tradeCurrencyOne.toJSON(),
    'trade_currency_two': tradeCurrencyTwo.toJSON(),
    'secret_hash': secretHash,
    'is_buyer': isBuyer,
    'secret': secret,
    'step': step,
  };

  Map<String, dynamic> toSafeJSON() => {
    'id': id,
    'trade_currency_one': tradeCurrencyOne.toJSON(),
    'trade_currency_two': tradeCurrencyTwo.toJSON(),
    'secret_hash': secretHash,
    'is_buyer': !isBuyer,
    'secret': null,
    'step': 0,
  };

  @override
  List<Object?> get props => [id, tradeCurrencyOne, tradeCurrencyTwo, secretHash, isBuyer, secret, step];
}