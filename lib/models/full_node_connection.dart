import 'package:equatable/equatable.dart';

enum FullNodeConnectionStatus {notConnected, notSynced, connected}

class FullNodeConnection extends Equatable {
  final String currency;
  final FullNodeConnectionStatus status;

  const FullNodeConnection({
    required this.currency,
    required this.status,
  });

  FullNodeConnection.fromJSON(Map<String, dynamic> data) :
    currency = data['currency'],
    status = data['status'] == 'connected' ? FullNodeConnectionStatus.connected :
      ( data['status'] == 'not_connected' ? FullNodeConnectionStatus.notConnected : FullNodeConnectionStatus.notSynced);

  @override
  List<Object?> get props => [currency, status];
}