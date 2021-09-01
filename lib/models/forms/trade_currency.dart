import 'package:formz/formz.dart';
import 'package:yakuswap/models/inputs/address.dart';
import 'package:yakuswap/models/inputs/address_prefix.dart';
import 'package:yakuswap/models/inputs/fee.dart';
import 'package:yakuswap/models/inputs/id.dart';
import 'package:yakuswap/models/inputs/max_block_height.dart';
import 'package:yakuswap/models/inputs/min_confirmation_height.dart';
import 'package:yakuswap/models/inputs/transaction_amount.dart';
import 'package:yakuswap/models/trade_currency.dart';

class TradeCurrencyForm with FormzMixin {
  final IdInput id;
  final AddressPrefixInput addressPrefix;
  final FeeInput fee;
  final MaxBlockHeightInput maxBlockHeight;
  final MinConfirmationHeightInput minConfirmationHeight;
  final AddressInput fromAddress;
  final AddressInput toAddress;
  final TransactionAmountInput totalAmount;

  const TradeCurrencyForm({
    this.id = const IdInput.pure(),
    this.addressPrefix = const AddressPrefixInput.pure(),
    this.fee = const FeeInput.pure(),
    this.maxBlockHeight = const MaxBlockHeightInput.pure(),
    this.minConfirmationHeight = const MinConfirmationHeightInput.pure(),
    this.fromAddress = const AddressInput.pure(),
    this.toAddress = const AddressInput.pure(),
    this.totalAmount = const TransactionAmountInput.pure(),
  });
  
  TradeCurrencyForm.fromTradeCurrency({required TradeCurrency tradeCurrency}) :
    id = IdInput.dirty(value: tradeCurrency.id),
    addressPrefix = AddressPrefixInput.dirty(value: tradeCurrency.addressPrefix),
    fee = FeeInput.dirty(value: "${tradeCurrency.fee}"),
    maxBlockHeight = MaxBlockHeightInput.dirty(value: "${tradeCurrency.maxBlockHeight}"),
    minConfirmationHeight = MinConfirmationHeightInput.dirty(value: "${tradeCurrency.minConfirmationHeight}"),
    fromAddress = AddressInput.dirty(value: tradeCurrency.fromAddress),
    toAddress = AddressInput.dirty(value: tradeCurrency.toAddress),
    totalAmount = TransactionAmountInput.dirty(value: "${tradeCurrency.totalAmount}");

  TradeCurrencyForm copyWith({
    IdInput? id,
    AddressPrefixInput? addressPrefix,
    FeeInput? fee,
    MaxBlockHeightInput? maxBlockHeight,
    MinConfirmationHeightInput? minConfirmationHeight,
    AddressInput? fromAddress,
    AddressInput? toAddress,
    TransactionAmountInput? totalAmount,
  }) => TradeCurrencyForm(
    id: id ?? this.id,
    addressPrefix: addressPrefix ?? this.addressPrefix,
    fee: fee ?? this.fee,
    maxBlockHeight: maxBlockHeight ?? this.maxBlockHeight,
    minConfirmationHeight: minConfirmationHeight ?? this.minConfirmationHeight,
    fromAddress: fromAddress ?? this.fromAddress,
    toAddress: toAddress ?? this.toAddress,
    totalAmount: totalAmount ?? this.totalAmount,
  );

  TradeCurrency? toTradeCurrency() => status == FormzStatus.valid ? TradeCurrency(
    id: id.value,
    addressPrefix: addressPrefix.value,
    fee: int.parse(fee.value),
    maxBlockHeight: int.parse(maxBlockHeight.value),
    minConfirmationHeight: int.parse(minConfirmationHeight.value),
    fromAddress: fromAddress.value,
    toAddress: toAddress.value,
    totalAmount: int.parse(totalAmount.value),
  ) : null;

  @override
  List<FormzInput> get inputs => [id, addressPrefix, fee, maxBlockHeight, minConfirmationHeight, fromAddress, toAddress, totalAmount];
}
