import 'package:equatable/equatable.dart';

class TradeCurrency extends Equatable {
  final String id;
  final String addressPrefix;
  final int fee;
  final int totalAmount;
  final int maxBlockHeight;
  final int minConfirmationHeight;
  final String fromAddress;
  final String toAddress;

  const TradeCurrency({
    required this.id,
    required this.addressPrefix,
    required this.fee,
    required this.totalAmount,
    required this.maxBlockHeight,
    required this.minConfirmationHeight,
    required this.fromAddress,
    required this.toAddress
  });

  TradeCurrency.fromJSON(Map<String, dynamic> data) :
    this.id = data['id'],
    this.addressPrefix = data['address_prefix'],
    this.fee = data['fee'],
    this.totalAmount = data['total_amount'],
    this.maxBlockHeight = data['max_block_height'],
    this.minConfirmationHeight = data['min_confirmation_height'],
    this.fromAddress = data['from_address'],
    this.toAddress = data['to_address'];

  Map<String, dynamic> toJSON() => {
    'id': this.id,
    'address_prefix': this.addressPrefix,
    'fee': this.fee,
    'total_amount': this.totalAmount,
    'max_block_height': this.maxBlockHeight,
    'min_confirmation_height': this.minConfirmationHeight,
    'from_address': this.fromAddress,
    'to_address': this.toAddress
  };

  @override
  List<Object?> get props => [id, addressPrefix, fee, totalAmount, maxBlockHeight, minConfirmationHeight, fromAddress, toAddress];
}