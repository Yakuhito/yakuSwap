import 'package:formz/formz.dart';
import 'package:yakuswap/models/forms/trade_currency.dart';
import 'package:yakuswap/models/inputs/address_prefix.dart';
import 'package:yakuswap/models/inputs/hash.dart';
import 'package:yakuswap/models/inputs/id.dart';
import 'package:yakuswap/models/inputs/secret.dart';
import 'package:yakuswap/models/inputs/step.dart';
import 'package:yakuswap/models/trade.dart';

class TradeForm with FormzMixin {
  final IdInput id;
  final TradeCurrencyForm tradeCurrencyOne;
  final TradeCurrencyForm tradeCurrencyTwo;
  final HashInput secretHash;
  final SecretInput secret;
  final StepInput step;
  final bool isBuyer;

  const TradeForm({
    this.id = const IdInput.pure(),
    this.tradeCurrencyOne = const TradeCurrencyForm(),
    this.tradeCurrencyTwo = const TradeCurrencyForm(),
    this.secretHash = const HashInput.pure(),
    this.secret = const SecretInput.pure(),
    this.step = const StepInput.pure(),
    this.isBuyer = true,
  });

  TradeForm autoGenerateFields() {
    final String secret = SecretInput.generateSecret();
    final String id = IdInput.generateId();

    return copyWith(
      id:  IdInput.dirty(value: id),
      tradeCurrencyOne: TradeCurrencyForm(id: IdInput.dirty(value: "$id-1"), addressPrefix: const AddressPrefixInput.dirty(value: "xch")),
      tradeCurrencyTwo: TradeCurrencyForm(id: IdInput.dirty(value: "$id-2"), addressPrefix: const AddressPrefixInput.dirty(value: "xch")),
      secret: SecretInput.dirty(value: secret),
      secretHash: HashInput.forSecret(secret: secret),
      step: const StepInput.dirty(value: "0"),
      isBuyer: true,
    );
  }

  TradeForm.fromTrade({required Trade trade}) :
    id = IdInput.dirty(value: trade.id),
    tradeCurrencyOne = TradeCurrencyForm.fromTradeCurrency(tradeCurrency: trade.tradeCurrencyOne),
    tradeCurrencyTwo = TradeCurrencyForm.fromTradeCurrency(tradeCurrency: trade.tradeCurrencyTwo),
    secretHash = HashInput.dirty(value: trade.secretHash),
    secret = SecretInput.dirty(value: trade.secret ?? ""),
    step = StepInput.dirty(value: "${trade.step}"),
    isBuyer = trade.isBuyer;

  TradeForm copyWith({
    IdInput? id,
    TradeCurrencyForm? tradeCurrencyOne,
    TradeCurrencyForm? tradeCurrencyTwo,
    HashInput? secretHash,
    SecretInput? secret,
    StepInput? step,
    bool? isBuyer,
  }) => TradeForm(
    id: id ?? this.id,
    tradeCurrencyOne: tradeCurrencyOne ?? this.tradeCurrencyOne,
    tradeCurrencyTwo: tradeCurrencyTwo ?? this.tradeCurrencyTwo,
    secretHash: secretHash ?? this.secretHash,
    secret: secret ?? this.secret,
    step: step ?? this.step,
    isBuyer: isBuyer ?? this.isBuyer,
  );

  Trade? toTrade() => status == FormzStatus.valid ? Trade(
    id: id.value,
    tradeCurrencyOne: tradeCurrencyOne.toTradeCurrency()!,
    tradeCurrencyTwo: tradeCurrencyTwo.toTradeCurrency()!,
    secretHash: secretHash.value,
    secret: secret.value.isEmpty ? null : secret.value,
    step: int.parse(step.value),
    isBuyer: isBuyer,
  ) : null;

  @override
  List<FormzInput> get inputs => [id, ...tradeCurrencyOne.inputs, ...tradeCurrencyTwo.inputs, secretHash, secret, step];
}
