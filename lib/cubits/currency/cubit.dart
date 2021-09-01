import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:yakuswap/models/currency.dart';
import 'package:yakuswap/models/forms/currency.dart';
import 'package:yakuswap/models/inputs/address_prefix.dart';
import 'package:yakuswap/models/inputs/directory.dart';
import 'package:yakuswap/models/inputs/host.dart';
import 'package:yakuswap/models/inputs/max_block_height.dart';
import 'package:yakuswap/models/inputs/min_confirmation_height.dart';
import 'package:yakuswap/models/inputs/port.dart';
import 'package:yakuswap/models/inputs/fee.dart';
import 'package:yakuswap/models/inputs/name.dart';
import 'package:yakuswap/models/inputs/photo_url.dart';
import 'package:yakuswap/models/inputs/units_per_coin.dart';

part 'state.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  CurrencyCubit({Currency? currency}) : super(currency == null ? const CurrencyState(form: CurrencyForm()) :
    CurrencyState(form: CurrencyForm.fromCurrency(currency: currency)));

  String import(String rawData) {
    String message = "";

    try {
      final Map<String, dynamic> json = jsonDecode(rawData);
      final Currency currency = Currency.fromJSON(json);
      final CurrencyState newState = CurrencyState(form: CurrencyForm.fromCurrency(currency: currency), forceReload: true);

      emit(newState);

      message = "Import from clipboard successful.";
    } catch(err) {
      message = "Could not import from clipboard: $err";
    }

    return message;
  }

  String export() {
    return jsonEncode(state.form.toCurrency()?.toJSON() ?? {});
  }

  void emitForceReload() {
    emit(state.copyWith(forceReload: true));
  }

  void changeAddressPrefix(String newVal) {
    emit(state.copyWith(
      form: state.form.copyWith(
        addressPrefix: AddressPrefixInput.dirty(value: newVal),
      ),
    ));
  }

  void changeName(String newVal) {
    emit(state.copyWith(
      form: state.form.copyWith(
        name: NameInput.dirty(value: newVal),
      ),
    ));
  }

  void changePhotoURL(String newVal) {
    emit(state.copyWith(
      form: state.form.copyWith(
        photoURL: PhotoURLInput.dirty(value: newVal),
      ),
    ));
  }

  void changeUnitsPerCoin(String newVal) {
    emit(state.copyWith(
      form: state.form.copyWith(
        unitsPerCoin: UnitsPerCoinInput.dirty(value: newVal),
      ),
    ));
  }

  void changeMinFee(String newVal) {
    emit(state.copyWith(
      form: state.form.copyWith(
        minFee: FeeInput.dirty(value: newVal),
      ),
    ));
  }

  void changeDefaultMaxBlockHeight(String newVal) {
    emit(state.copyWith(
      form: state.form.copyWith(
        defaultMaxBlockHeight: MaxBlockHeightInput.dirty(value: newVal),
      ),
    ));
  }

  void changeDefaultMinConfirmationHeight(String newVal) {
    emit(state.copyWith(
      form: state.form.copyWith(
        defaultMinConfirmationHeight: MinConfirmationHeightInput.dirty(value: newVal),
      ),
    ));
  }

  void changeHost(String newVal) {
    emit(state.copyWith(
      form: state.form.copyWith(
        host: HostInput.dirty(value: newVal),
      ),
    ));
  }

  void changePort(String newVal) {
    emit(state.copyWith(
      form: state.form.copyWith(
        port: PortInput.dirty(value: newVal),
      ),
    ));
  }

  void changeSslDirectory(String newVal) {
    emit(state.copyWith(
      form: state.form.copyWith(
        sslDirectory: DirectoryInput.dirty(value: newVal),
      ),
    ));
  }
}