import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:yakuswap/models/forms/trade.dart';
import 'package:yakuswap/models/forms/trade_currency.dart';
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
      final TradeState newState = TradeState(form: TradeForm.fromTrade(trade: trade), forceReload: true);

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
    ));
  }

  void changeTradeCurrencyTwo(TradeCurrencyForm newVal) {
    emit(state.copyWith(
      form: state.form.copyWith(
        tradeCurrencyTwo: newVal,
      ),
    ));
  }

  void toggleIsBuyer() {
    emit(state.copyWith(
      form: state.form.copyWith(
        isBuyer: !state.form.isBuyer,
      ),
    ));
  }

  void changeStep(String newVal) {
    emit(state.copyWith(
      form: state.form.copyWith(
        step: StepInput.dirty(value: newVal),
      ),
    ));
  }
}