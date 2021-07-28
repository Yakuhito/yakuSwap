import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:yakuswap/models/trade_status.dart';
import 'package:yakuswap/repositories/allinone.dart';

part 'state.dart';

class TradeStatusCubit extends Cubit<TradeStatusState> {
  final AllInOneRepository allInOneRepository;
  final String tradeId;
  bool requestInProgress = false;

  late final Timer _timer;
  TradeStatusCubit({required this.allInOneRepository, required this.tradeId}) : super(
    TradeStatusState(tradeStatus: TradeStatus(address: null, message: "Fetching..."), tradeId: tradeId)
    ) {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => update());
  }

  Future<void> update() async {
    if(requestInProgress) return;
    requestInProgress = true;
    final TradeStatus newStatus = await allInOneRepository.getTrade(tradeId: tradeId);
    emit(TradeStatusState(
      tradeId: tradeId,
      tradeStatus: newStatus
    ));
    requestInProgress = false;
  }

  @override
  Future<void> close() {
    _timer.cancel();
    return super.close();
  }
}