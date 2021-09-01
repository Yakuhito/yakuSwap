part of 'cubit.dart';

class TradeStatusState extends Equatable {
  final TradeStatus tradeStatus;
  final String tradeId;

  const TradeStatusState({required this.tradeStatus, required this.tradeId});

  @override
  List<Object?> get props => [tradeStatus, tradeId];
}