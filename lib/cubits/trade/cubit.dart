import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:yakuswap/models/forms/trade.dart';
import 'package:yakuswap/models/forms/trade_currency.dart';
import 'package:yakuswap/models/inputs/hash.dart';
import 'package:yakuswap/models/inputs/step.dart';
import 'package:yakuswap/models/trade.dart';

part 'state.dart';

class TradeCubit extends Cubit<TradeState> {
  TradeCubit({Trade? trade}) : super(trade == null ? TradeState(form: const TradeForm().autoGenerateFields()) :
    TradeState(form: TradeForm.fromTrade(trade: trade)));

  String import(String rawData) {
    String message = "";

    try {
      final Map<String, dynamic> json = jsonDecode(rawData);
      final Trade trade = Trade.fromJSON(json);
      String warning = "";

      if(trade.tradeCurrencyOne.fee < (trade.tradeCurrencyOne.totalAmount / 10000).ceil() ||
        trade.tradeCurrencyOne.maxBlockHeight != 192 ||
        trade.tradeCurrencyOne.minConfirmationHeight != 32 ||
        trade.tradeCurrencyTwo.fee < (trade.tradeCurrencyTwo.totalAmount / 10000).ceil() ||
        trade.tradeCurrencyTwo.maxBlockHeight != 192 ||
        trade.tradeCurrencyTwo.minConfirmationHeight != 32 ||
        trade.step != 0) {
        warning = "WARNING: Imported trade contains some non-default parameters that you mign not be able to see - proceed with extreme caution ONLY IF you know what you are doing.";
      }

      final TradeState newState = TradeState(form: TradeForm.fromTrade(trade: trade), forceReload: true, warning: warning);
      emit(newState);

      message = "Import from clipboard successful.";
    } catch(err) {
      message = "Could not import from clipboard: $err";
    }

    return message;
  }

  String export() {
    return jsonEncode(state.form.toTrade()?.toJSON() ?? {});
  }

  String safeExport() {
    return jsonEncode(state.form.toTrade()?.toSafeJSON() ?? {});
  }

  void emitForceReload() {
    emit(state.copyWith(forceReload: true));
  }

  void changeTradeCurrencyOne(TradeCurrencyForm newVal) {
    emit(state.copyWith(
      form: state.form.copyWith(
        tradeCurrencyOne: newVal,
      ),
      forceReload: false,
    ));
  }

  void changeTradeCurrencyTwo(TradeCurrencyForm newVal) {
    emit(state.copyWith(
      form: state.form.copyWith(
        tradeCurrencyTwo: newVal,
      ),
      forceReload: false,
    ));
  }

  void toggleIsBuyer() {
    emit(state.copyWith(
      form: state.form.copyWith(
        isBuyer: !state.form.isBuyer,
      ),
      forceReload: false,
    ));
  }

  void changeStep(String newVal) {
    emit(state.copyWith(
      form: state.form.copyWith(
        step: StepInput.dirty(value: newVal),
      ),
      forceReload: false,
    ));
  }

  void changeSecretHash(String newVal) {
    emit(state.copyWith(
      form: state.form.copyWith(
        secretHash: HashInput.dirty(value: newVal),
      ),
      forceReload: false,
    ));
  }
}