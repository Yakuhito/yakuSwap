import 'package:equatable/equatable.dart';

class TradeStatus extends Equatable {
  final String message;
  final String? address;

  const TradeStatus({
    required this.message,
    required this.address,
  });

  TradeStatus.fromJSON(Map<String, dynamic> data) :
    this.message = data['message'],
    this.address = data['address'];

  @override
  List<Object?> get props => [message, address];
}