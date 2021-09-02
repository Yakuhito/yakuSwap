import 'package:equatable/equatable.dart';

import 'command.dart';

class TradeStatus extends Equatable {
  final String message;
  final String? address;
  final Command? command;

  const TradeStatus({
    required this.message,
    required this.address,
    this.command,
  });

  TradeStatus.fromJSON(Map<String, dynamic> data) :
    message = data['message'],
    address = data.containsKey("address") && data["address"] != null ? data['address'] : null,
    command = data.containsKey("command") && data["command"] != null ? Command.fromJSON(data['command']) : null;

  @override
  List<Object?> get props => [message, address, command];
}