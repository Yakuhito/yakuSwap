import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:yakuswap/models/eth_trade.dart';
import 'package:yakuswap/models/forms/eth_trade.dart';
import 'package:yakuswap/models/forms/trade_currency.dart';
import 'package:yakuswap/models/inputs/eth_adress.dart';
import 'package:yakuswap/models/inputs/fee.dart';
import 'package:yakuswap/models/inputs/hash.dart';
import 'package:yakuswap/models/inputs/transaction_amount.dart';

part 'state.dart';

class EthTradeCubit extends Cubit<EthTradeState> {
  EthTradeCubit({EthTrade? trade}) : super(trade == null ? EthTradeState(form: const EthTradeForm().autoGenerateFields()) :
    EthTradeState(form: EthTradeForm.fromTrade(trade: trade)));

  String import(String rawData) {
    String message = "";

    try {
      final Map<String, dynamic> json = jsonDecode(rawData);
      final EthTrade trade = EthTrade.fromJSON(json);
      String warning = "";

      if(trade.tradeCurrency.fee < (trade.tradeCurrency.totalAmount / 10000).ceil() ||
        trade.tradeCurrency.maxBlockHeight != 192 ||
        trade.tradeCurrency.minConfirmationHeight != 32 ||
        trade.step != 0) {
        warning = "WARNING: Imported trade contains some non-default parameters that you don't see - proceed with extreme caution ONLY IF you know what you are doing.";
      }

      final EthTradeState newState = EthTradeState(form: EthTradeForm.fromTrade(trade: trade), forceReload: true, warning: warning);
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

  void changeTradeCurrency(TradeCurrencyForm newVal) {
    if(newVal.totalAmount.valid) {
      newVal = newVal.copyWith(
        fee: FeeInput.dirty(value: (int.parse(newVal.totalAmount.value) / 10000).ceil().toString()),
      );
    }
    emit(state.copyWith(
      form: state.form.copyWith(
        tradeCurrency: newVal,
      ),
      forceReload: false,
    ));
  }

  void changeIsBuyer(bool newVal) {
    emit(state.copyWith(
      form: state.form.copyWith(
        isBuyer: newVal,
      ),
      forceReload: false,
    ));
  }

  void changeEthFromAddress(String newVal) {
    emit(state.copyWith(
      form: state.form.copyWith(
        ethFromAddress: EthAddressInput.dirty(value: newVal),
      ),
      forceReload: false,
    ));
  }

  void changeEthToAddress(String newVal) {
    emit(state.copyWith(
      form: state.form.copyWith(
        ethToAddress: EthAddressInput.dirty(value: newVal),
      ),
      forceReload: false,
    ));
  }

  void changeEthTotalWei(String newVal) {
    emit(state.copyWith(
      form: state.form.copyWith(
        ethTotalGwei: TransactionAmountInput.dirty(value: newVal),
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

  void changeNetwork(String newVal, String newToken) {
    emit(state.copyWith(
      form: state.form.copyWith(
        network: newVal,
        token: newToken
      ),
      forceReload: true,
    ));
  }

  void changeToken(String newVal) {
    emit(state.copyWith(
      form: state.form.copyWith(
        token: newVal,
      ),
      forceReload: false,
    ));
  }
}