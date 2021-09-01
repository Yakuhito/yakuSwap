import 'package:formz/formz.dart';
import 'package:yakuswap/models/eth_trade.dart';
import 'package:yakuswap/models/forms/trade_currency.dart';
import 'package:yakuswap/models/inputs/address_prefix.dart';
import 'package:yakuswap/models/inputs/eth_adress.dart';
import 'package:yakuswap/models/inputs/hash.dart';
import 'package:yakuswap/models/inputs/id.dart';
import 'package:yakuswap/models/inputs/max_block_height.dart';
import 'package:yakuswap/models/inputs/min_confirmation_height.dart';
import 'package:yakuswap/models/inputs/secret.dart';
import 'package:yakuswap/models/inputs/step.dart';
import 'package:yakuswap/models/inputs/transaction_amount.dart';

class EthTradeForm with FormzMixin {
  final IdInput id;
  final TradeCurrencyForm tradeCurrency;
  final EthAddressInput ethFromAddress;
  final EthAddressInput ethToAddress;
  final TransactionAmountInput ethTotalWei;
  final HashInput secretHash;
  final SecretInput secret;
  final StepInput step;
  final bool isBuyer;

  const EthTradeForm({
    this.id = const IdInput.pure(),
    this.tradeCurrency = const TradeCurrencyForm(),
    this.ethFromAddress = const EthAddressInput.pure(),
    this.ethToAddress = const EthAddressInput.pure(),
    this.ethTotalWei = const TransactionAmountInput.pure(),
    this.secretHash = const HashInput.pure(),
    this.secret = const SecretInput.pure(),
    this.step = const StepInput.pure(),
    this.isBuyer = true,
  });

  EthTradeForm autoGenerateFields() {
    final String secret = SecretInput.generateSecret();
    final String id = IdInput.generateId();

    return copyWith(
      id:  IdInput.dirty(value: id),
      tradeCurrency: TradeCurrencyForm(
        id: IdInput.dirty(value: "$id-1"),
        addressPrefix: const AddressPrefixInput.dirty(value: "xch"),
        maxBlockHeight: const MaxBlockHeightInput.dirty(value: "192"),
        minConfirmationHeight: const MinConfirmationHeightInput.dirty(value: "32"),
      ),
      secretHash: HashInput.forSecret(secret: secret),
      secret: SecretInput.dirty(value: secret),
      step: const StepInput.dirty(value: "0"),
      isBuyer: true,
    );
  }

  EthTradeForm.fromTrade({required EthTrade trade}) :
    id = IdInput.dirty(value: trade.id),
    tradeCurrency = TradeCurrencyForm.fromTradeCurrency(tradeCurrency: trade.tradeCurrency),
    ethFromAddress = EthAddressInput.dirty(value: trade.ethFromAddress),
    ethToAddress = EthAddressInput.dirty(value: trade.ethFromAddress),
    ethTotalWei = TransactionAmountInput.dirty(value: trade.totalWei.toString()),
    secretHash = HashInput.dirty(value: trade.secretHash),
    secret = SecretInput.dirty(value: trade.secret ?? ""),
    step = StepInput.dirty(value: "${trade.step}"),
    isBuyer = trade.isBuyer;

  EthTradeForm copyWith({
    IdInput? id,
    TradeCurrencyForm? tradeCurrency,
    EthAddressInput? ethFromAddress,
    EthAddressInput? ethToAddress,
    TransactionAmountInput? ethTotalWei,
    HashInput? secretHash,
    SecretInput? secret,
    StepInput? step,
    bool? isBuyer,
  }) => EthTradeForm(
    id: id ?? this.id,
    tradeCurrency: tradeCurrency ?? this.tradeCurrency,
    ethFromAddress: ethFromAddress ?? this.ethFromAddress,
    ethToAddress: ethToAddress ?? this.ethToAddress,
    ethTotalWei: ethTotalWei ?? this.ethTotalWei,
    secretHash: secretHash ?? this.secretHash,
    secret: secret ?? this.secret,
    step: step ?? this.step,
    isBuyer: isBuyer ?? this.isBuyer,
  );

  EthTrade? toTrade() => status == FormzStatus.valid ? EthTrade(
    id: id.value,
    tradeCurrency: tradeCurrency.toTradeCurrency()!,
    ethFromAddress: ethFromAddress.value,
    ethToAddress: ethToAddress.value,
    totalWei: int.parse(ethTotalWei.value),
    secretHash: secretHash.value,
    secret: secret.value.isEmpty ? null : secret.value,
    step: int.parse(step.value),
    isBuyer: isBuyer,
  ) : null;

  @override
  List<FormzInput> get inputs => [id, ...tradeCurrency.inputs, ethFromAddress, ethToAddress, ethTotalWei, secretHash, secret, step];
}
