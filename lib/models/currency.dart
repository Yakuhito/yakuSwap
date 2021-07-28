import 'package:equatable/equatable.dart';

class Currency extends Equatable {
  final String addressPrefix;
  final String name;
  final String photoUrl;
  final int unitsPerCoin;
  final int minFee;
  final int defaultMaxBlockHeight;
  final int defaultMinConfirmationHeight;
  final String host;
  final int port;
  final String sslDirectory;

  const Currency({
    required this.addressPrefix,
    required this.name,
    required this.photoUrl,
    required this.unitsPerCoin,
    required this.minFee,
    required this.defaultMaxBlockHeight,
    required this.defaultMinConfirmationHeight,
    required this.host,
    required this.port,
    required this.sslDirectory,
  });

  Currency.fromJSON(Map<String, dynamic> data) :
    this.addressPrefix = data['address_prefix'],
    this.name = data['name'],
    this.photoUrl = data['photo_url'],
    this.unitsPerCoin = data['units_per_coin'],
    this.minFee = data['min_fee'],
    this.defaultMaxBlockHeight = data['default_max_block_height'],
    this.defaultMinConfirmationHeight = data['default_min_confirmation_height'],
    this.host = data['host'],
    this.port = data['port'],
    this.sslDirectory = data['ssl_directory'];

  Map<String, dynamic> toJSON() => {
    'address_prefix': this.addressPrefix,
    'name': this.name,
    'photo_url': this.photoUrl,
    'units_per_coin': this.unitsPerCoin,
    'min_fee': this.minFee,
    'default_max_block_height': this.defaultMaxBlockHeight,
    'default_min_confirmation_height': this.defaultMinConfirmationHeight,
    'host': this.host,
    'port': this.port,
    'ssl_directory': this.sslDirectory,
  };

  @override
  List<Object?> get props => [addressPrefix, name, photoUrl, unitsPerCoin, minFee, defaultMaxBlockHeight, defaultMinConfirmationHeight, host, port, sslDirectory];
}