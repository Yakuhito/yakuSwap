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
    addressPrefix = data['address_prefix'],
    name = data['name'],
    photoUrl = data['photo_url'],
    unitsPerCoin = data['units_per_coin'],
    minFee = data['min_fee'],
    defaultMaxBlockHeight = data['default_max_block_height'],
    defaultMinConfirmationHeight = data['default_min_confirmation_height'],
    host = data['host'],
    port = data['port'],
    sslDirectory = data['ssl_directory'];

  Map<String, dynamic> toJSON() => {
    'address_prefix': addressPrefix,
    'name': name,
    'photo_url': photoUrl,
    'units_per_coin': unitsPerCoin,
    'min_fee': minFee,
    'default_max_block_height': defaultMaxBlockHeight,
    'default_min_confirmation_height': defaultMinConfirmationHeight,
    'host': host,
    'port': port,
    'ssl_directory': sslDirectory,
  };

  @override
  List<Object?> get props => [addressPrefix, name, photoUrl, unitsPerCoin, minFee, defaultMaxBlockHeight, defaultMinConfirmationHeight, host, port, sslDirectory];
}