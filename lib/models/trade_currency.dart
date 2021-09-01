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
    id = data['id'],
    addressPrefix = data['address_prefix'],
    fee = data['fee'],
    totalAmount = data['total_amount'],
    maxBlockHeight = data['max_block_height'],
    minConfirmationHeight = data['min_confirmation_height'],
    fromAddress = data['from_address'],
    toAddress = data['to_address'];

  Map<String, dynamic> toJSON() => {
    'id': id,
    'address_prefix': addressPrefix,
    'fee': fee,
    'total_amount': totalAmount,
    'max_block_height': maxBlockHeight,
    'min_confirmation_height': minConfirmationHeight,
    'from_address': fromAddress,
    'to_address': toAddress
  };

  @override
  List<Object?> get props => [id, addressPrefix, fee, totalAmount, maxBlockHeight, minConfirmationHeight, fromAddress, toAddress];
}