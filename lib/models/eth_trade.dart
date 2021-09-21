import 'package:equatable/equatable.dart';
import 'package:yakuswap/models/trade_currency.dart';

class EthTrade extends Equatable {
  final String id;
  final TradeCurrency tradeCurrency;
  final String ethFromAddress;
  final String ethToAddress;
  final int totalGwei;
  final String secretHash;
  final bool isBuyer;
  final String? secret;
  final int step;
  final String network;
  final String token;

  const EthTrade({
    required this.id,
    required this.tradeCurrency,
    required this.ethFromAddress,
    required this.ethToAddress,
    required this.totalGwei,
    required this.secretHash,
    required this.isBuyer,
    required this.secret,
    required this.step,
    required this.network,
    required this.token,
  });

  EthTrade.fromJSON(Map<String, dynamic> data) :
    id = data['id'],
    tradeCurrency = TradeCurrency.fromJSON(data['trade_currency']),
    ethFromAddress = data['eth_from_address'],
    ethToAddress = data['eth_to_address'],
    totalGwei = data['total_gwei'],
    secretHash = data['secret_hash'],
    isBuyer = data['is_buyer'],
    secret = data['secret'],
    step = data['step'],
    network = data['network'],
    token = data['token'];

  Map<String, dynamic> toJSON() => {
    'id': id,
    'trade_currency': tradeCurrency.toJSON(),
    'eth_from_address': ethFromAddress,
    'eth_to_address': ethToAddress,
    'total_gwei': totalGwei,
    'secret_hash': secretHash,
    'is_buyer': isBuyer,
    'secret': secret,
    'step': step,
    'network': network,
    'token': token,
  };

  Map<String, dynamic> toSafeJSON() => {
    'id': id,
    'trade_currency': tradeCurrency.toJSON(),
    'eth_from_address': ethFromAddress,
    'eth_to_address': ethToAddress,
    'total_gwei': totalGwei,
    'secret_hash': secretHash,
    'is_buyer': !isBuyer,
    'secret': null,
    'step': 0,
    'network': network,
    'token': token,
  };

  @override
  List<Object?> get props => [id, tradeCurrency, ethFromAddress, ethToAddress, totalGwei, secretHash, isBuyer, secret, step, network, token];
}