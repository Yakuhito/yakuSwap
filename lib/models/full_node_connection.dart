import 'package:equatable/equatable.dart';

enum FullNodeConnectionStatus {not_connected, not_synced, connected}

class FullNodeConnection extends Equatable {
  final String currency;
  final FullNodeConnectionStatus status;

  const FullNodeConnection({
    required this.currency,
    required this.status,
  });

  FullNodeConnection.fromJSON(Map<String, dynamic> data) :
    this.currency = data['currency'],
    this.status = data['status'] == 'connected' ? FullNodeConnectionStatus.connected :
      ( data['status'] == 'not_connected' ? FullNodeConnectionStatus.not_connected : FullNodeConnectionStatus.not_synced);

  @override
  List<Object?> get props => [currency, status];
}