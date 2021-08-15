import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yakuswap/cubits/currencies_and_trades/cubit.dart';
import 'package:yakuswap/cubits/trade/cubit.dart';
import 'package:yakuswap/models/currency.dart';
import 'package:yakuswap/models/forms/trade_currency.dart';
import 'package:yakuswap/models/inputs/address.dart';
import 'package:yakuswap/models/inputs/address_prefix.dart';
import 'package:yakuswap/models/inputs/fee.dart';
import 'package:yakuswap/models/inputs/hash.dart';
import 'package:yakuswap/models/inputs/id.dart';
import 'package:yakuswap/models/inputs/max_block_height.dart';
import 'package:yakuswap/models/inputs/min_confirmation_height.dart';
import 'package:yakuswap/models/inputs/secret.dart';
import 'package:yakuswap/models/inputs/step.dart';
import 'package:yakuswap/models/inputs/transaction_amount.dart';
import 'package:yakuswap/models/trade.dart';

class TradeScreen extends StatelessWidget {
  final Trade? trade;

  const TradeScreen({this.trade, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trade != null ? "Edit trade" : "New trade"),
      ),
      body: BlocProvider<TradeCubit>(
        create: (context) => TradeCubit(trade: trade),
        child: _Body(
          showDeleteButton: trade != null,
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final bool showDeleteButton;

  const _Body({this.showDeleteButton = false, Key? key}) : super(key: key);

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradeCubit, TradeState>(
      builder: (context, state) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24.0,
            horizontal: 12.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton.icon(
                icon: Icon(Icons.arrow_circle_up_outlined),
                label: Text("Export"),
                onPressed: () async {
                  final String exportString =
                      BlocProvider.of<TradeCubit>(context).export();
                  await Clipboard.setData(ClipboardData(text: exportString));
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                          content: Text(
                              "Trade data copied to clipboard - the export contains your SECRET, so DO NOT SHARE IT WITH ANYBODY!")),
                    );
                },
              ),
              const SizedBox(height: 8.0),
              OutlinedButton.icon(
                icon: Icon(Icons.arrow_circle_down_outlined),
                label: Text("Import"),
                onPressed: () async {
                  final ClipboardData? clipboardData =
                      await Clipboard.getData("text/plain");
                  final String importStr = clipboardData?.text ?? "";
                  String message = "";

                  if (importStr.length > 0) {
                    message =
                        BlocProvider.of<TradeCubit>(context).import(importStr);
                  } else {
                    message = "Could not read data from your clipboard";
                  }
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                },
              ),
              const SizedBox(height: 8.0),
              OutlinedButton.icon(
                icon: Icon(Icons.share),
                label: Text("Share"),
                onPressed: () async {
                  final String exportString =
                      BlocProvider.of<TradeCubit>(context).safeExport();
                  await Clipboard.setData(ClipboardData(text: exportString));
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                          content: Text(
                              "Data copied to clipboard - you can share it with your trade partner")),
                    );
                },
              ),
              const SizedBox(height: 16.0),
              _TradeCurrencyForm(
                title: "Currency One",
                onFormChanged: (newForm) => BlocProvider.of<TradeCubit>(context)
                    .changeTradeCurrencyOne(newForm),
                form: state.form.tradeCurrencyOne,
                isSender: state.form.isBuyer,
              ),
              const SizedBox(height: 32.0),
              const Text(
                "Warning: Some forks use a very old Chia codebase and can only act as currency one. For your safety, only XCH can be used as currency two for now.",
                style: TextStyle(color: Colors.purple),
              ),
              const SizedBox(height: 16.0),
              _TradeCurrencyForm(
                title: "Currency Two",
                onFormChanged: (newForm) => BlocProvider.of<TradeCubit>(context)
                    .changeTradeCurrencyTwo(newForm),
                form: state.form.tradeCurrencyTwo,
                isSender: !state.form.isBuyer,
                lock: true,
              ),
              const SizedBox(height: 48.0),
              _SectionTitle(title: "Trade Info"),
              TextFormField(
                key: Key("tradeForm_id_${state.form.id.value}"),
                initialValue: state.form.id.value,
                decoration: InputDecoration(
                  labelText: IdInput.labelText,
                  hintText: IdInput.hintText,
                  errorText: state.form.id.pure ? null : state.form.id.error,
                ),
                enabled: false,
              ),
              TextFormField(
                key: Key("tradeForm_secretHash_${state.form.secretHash.value}"),
                initialValue: state.form.secretHash.value,
                decoration: InputDecoration(
                  labelText: HashInput.labelText,
                  hintText: HashInput.hintText,
                  errorText: state.form.secretHash.pure
                      ? null
                      : state.form.secretHash.error,
                ),
                enabled: false,
              ),
              TextFormField(
                key: Key("tradeForm_secret_${state.form.secret.value}"),
                initialValue: state.form.secret.value,
                decoration: InputDecoration(
                  labelText: SecretInput.labelText + " (DO NOT SHARE)",
                  hintText: SecretInput.hintText,
                  errorText:
                      state.form.secret.pure ? null : state.form.secret.error,
                ),
                enabled: false,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: TextFormField(
                      key: Key("tradeForm_step_${state.form.step.value}"),
                      initialValue: state.form.step.value,
                      decoration: InputDecoration(
                        labelText: StepInput.labelText,
                        hintText: StepInput.hintText,
                        errorText:
                            state.form.step.pure ? null : state.form.step.error,
                      ),
                      enabled: false,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Flexible(
                    flex: 2,
                    child: TextFormField(
                      key: Key("tradeForm_isBuyer_${state.form.isBuyer}"),
                      initialValue: state.form.isBuyer ? "YES" : "NO",
                      decoration: InputDecoration(
                        labelText: "Will initiate trade?",
                      ),
                      enabled: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                child: const Text("Save"),
                onPressed: state.canSubmit
                    ? () {
                        final Trade? c = state.form.toTrade();
                        Navigator.of(context).pop(c);
                      }
                    : null,
              ),
              const SizedBox(height: 8.0),
              widget.showDeleteButton
                  ? ElevatedButton(
                      child: const Text("Delete"),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      onPressed: state.canSubmit
                          ? () async {
                              final dynamic confirm = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Are you sure?"),
                                  content: Text(
                                      "Do you really want to delete this trade?"),
                                  actions: [
                                    TextButton(
                                      child: Text("Cancel"),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                    TextButton(
                                      child: Text("DELETE"),
                                      style: TextButton.styleFrom(
                                          primary: Colors.red),
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                    ),
                                  ],
                                ),
                              );
                              Navigator.of(context).pop(confirm);
                            }
                          : null,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? comment;
  const _SectionTitle({required this.title, this.comment, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        const SizedBox(width: 8.0),
        Expanded(child: Divider()),
        comment == null ? const SizedBox.shrink() : const SizedBox(width: 8.0),
        comment == null ? const SizedBox.shrink() : Text(comment!),
      ],
    );
  }
}

class _TradeCurrencyForm extends StatefulWidget {
  final Function(TradeCurrencyForm newForm) onFormChanged;
  final String title;
  final TradeCurrencyForm form;
  final bool isSender;
  final bool lock;

  const _TradeCurrencyForm(
      {required this.title,
      required this.onFormChanged,
      required this.form,
      required this.isSender,
      this.lock = false,
      Key? key})
      : super(key: key);

  @override
  __TradeCurrencyFormState createState() => __TradeCurrencyFormState();
}

class __TradeCurrencyFormState extends State<_TradeCurrencyForm> {
  late final TextEditingController _idController;
  late final TextEditingController _feeController;
  late final TextEditingController _maxBlockHeightController;
  late final TextEditingController _minConfirmationHeightController;
  late final TextEditingController _fromAddressController;
  late final TextEditingController _toAddressController;
  late final TextEditingController _totalAmountController;

  @override
  void initState() {
    _idController = TextEditingController(text: widget.form.id.value);
    _feeController = TextEditingController(text: widget.form.fee.value);
    _maxBlockHeightController =
        TextEditingController(text: widget.form.maxBlockHeight.value);
    _minConfirmationHeightController =
        TextEditingController(text: widget.form.minConfirmationHeight.value);
    _fromAddressController =
        TextEditingController(text: widget.form.fromAddress.value);
    _toAddressController =
        TextEditingController(text: widget.form.toAddress.value);
    _totalAmountController =
        TextEditingController(text: widget.form.totalAmount.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> currencyPrefixes =
        BlocProvider.of<CurrenciesAndTradesCubit>(context)
            .state
            .currencies!
            .map((e) => e.addressPrefix)
            .toList();

    return BlocListener<TradeCubit, TradeState>(
      listenWhen: (oldState, newState) => newState.forceReload,
      listener: (context, state) async {
        await Future.delayed(const Duration(milliseconds: 250));
        _idController.text = widget.form.id.value;
        _feeController.text = widget.form.fee.value;
        _maxBlockHeightController.text = widget.form.maxBlockHeight.value;
        _minConfirmationHeightController.text =
            widget.form.minConfirmationHeight.value;
        _fromAddressController.text = widget.form.fromAddress.value;
        _toAddressController.text = widget.form.toAddress.value;
        _totalAmountController.text = widget.form.totalAmount.value;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionTitle(
              title: widget.title,
              comment: widget.isSender
                  ? "You are the SENDER"
                  : "You are the RECEIVER"),
          TextFormField(
            controller: _idController,
            decoration: InputDecoration(
              labelText: IdInput.labelText,
              hintText: IdInput.hintText,
              errorText: widget.form.id.pure ? null : widget.form.id.error,
            ),
            onChanged: (newVal) => widget.onFormChanged(
                widget.form.copyWith(id: IdInput.dirty(value: newVal))),
            enabled: false,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: DropdownButtonFormField<String>(
                  key: Key(
                      "tradeCurrencyForm_${widget.title}_adddressPrefix_${widget.form.addressPrefix.value}"),
                  value: widget.form.addressPrefix.value,
                  /*decoration: InputDecoration(
                    labelText: FeeInput.labelText,
                  ),*/
                  onChanged: widget.lock ? null : (newVal) => widget.onFormChanged(widget.form
                      .copyWith(
                          addressPrefix:
                              AddressPrefixInput.dirty(value: newVal!))),
                  items: currencyPrefixes
                      .map((prefix) => DropdownMenuItem<String>(
                            value: prefix,
                            child: Text(prefix),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(width: 16.0),
              Flexible(
                flex: 4,
                child: TextFormField(
                  controller: _feeController,
                  decoration: InputDecoration(
                    labelText: FeeInput.labelText,
                    hintText: FeeInput.hintText,
                    errorText:
                        widget.form.fee.pure ? null : widget.form.fee.error,
                    helperText: _getFeeHelper(
                        widget.form.fee.value, widget.form.addressPrefix.value, widget.form.totalAmount.value),
                  ),
                  onChanged: (newVal) => widget.onFormChanged(
                      widget.form.copyWith(fee: FeeInput.dirty(value: newVal))),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: TextFormField(
                  controller: _maxBlockHeightController,
                  decoration: InputDecoration(
                    labelText: MaxBlockHeightInput.labelText + " (age)",
                    hintText: MaxBlockHeightInput.hintText,
                    errorText: widget.form.maxBlockHeight.pure
                        ? null
                        : widget.form.maxBlockHeight.error,
                    helperText: _getMaxBlockHeightHelper(
                        widget.form.maxBlockHeight.value,
                        widget.form.addressPrefix.value),
                  ),
                  onChanged: (newVal) => widget.onFormChanged(widget.form
                      .copyWith(
                          maxBlockHeight:
                              MaxBlockHeightInput.dirty(value: newVal))),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8.0),
              Flexible(
                flex: 1,
                child: TextFormField(
                  controller: _minConfirmationHeightController,
                  decoration: InputDecoration(
                    labelText: MinConfirmationHeightInput.labelText,
                    hintText: MinConfirmationHeightInput.hintText,
                    errorText: widget.form.minConfirmationHeight.pure
                        ? null
                        : widget.form.minConfirmationHeight.error,
                    helperText: _getMinConfirmationHeightHelper(
                        widget.form.minConfirmationHeight.value,
                        widget.form.addressPrefix.value),
                  ),
                  onChanged: (newVal) => widget.onFormChanged(widget.form
                      .copyWith(
                          minConfirmationHeight:
                              MinConfirmationHeightInput.dirty(value: newVal))),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          TextFormField(
            controller: _fromAddressController,
            decoration: InputDecoration(
              labelText: AddressInput.labelText + " (sender)",
              hintText: AddressInput.hintText,
              errorText: widget.form.fromAddress.pure
                  ? null
                  : widget.form.fromAddress.error,
            ),
            onChanged: (newVal) => widget.onFormChanged(widget.form
                .copyWith(fromAddress: AddressInput.dirty(value: newVal))),
          ),
          TextFormField(
            controller: _toAddressController,
            decoration: InputDecoration(
              labelText: AddressInput.labelText + " (receiver)",
              hintText: AddressInput.hintText,
              errorText: widget.form.toAddress.pure
                  ? null
                  : widget.form.toAddress.error,
            ),
            onChanged: (newVal) => widget.onFormChanged(widget.form
                .copyWith(toAddress: AddressInput.dirty(value: newVal))),
          ),
          TextFormField(
            controller: _totalAmountController,
            decoration: InputDecoration(
              labelText: TransactionAmountInput.labelText,
              hintText: TransactionAmountInput.hintText,
              errorText: widget.form.totalAmount.pure
                  ? null
                  : widget.form.totalAmount.error,
              helperText: _getAmountHelper(
                widget.form.totalAmount.value, widget.form.addressPrefix.value
              ),
            ),
            onChanged: (newVal) => widget.onFormChanged(widget.form.copyWith(
                totalAmount: TransactionAmountInput.dirty(value: newVal))),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  String? _getAmountHelper(String amount, String prefix) {
    if (int.tryParse(amount) == null) return null;
    final List<Currency> currencies =
        BlocProvider.of<CurrenciesAndTradesCubit>(context).state.currencies!;
    final Currency currency =
        currencies.firstWhere((element) => element.addressPrefix == prefix);
    int amnt = int.parse(amount);
    final int units = (amnt / currency.unitsPerCoin).floor();
    String s = "$units.";
    amnt = amnt - units * currency.unitsPerCoin;
    for(int pow = 1; pow * amnt * 10 < currency.unitsPerCoin; pow *= 10)
      s += "0";
    s += "$amnt ${currency.addressPrefix.toUpperCase()}";
    return s;
  }

  String? _getFeeHelper(String amount, String prefix, String transactionAmount) {
    if (int.tryParse(amount) == null) return null;
    final int? transAmount = int.tryParse(transactionAmount);
    final List<Currency> currencies =
        BlocProvider.of<CurrenciesAndTradesCubit>(context).state.currencies!;
    final Currency currency =
        currencies.firstWhere((element) => element.addressPrefix == prefix);
    if (int.parse(amount) >= currency.minFee) {
      if(transAmount == null) return null;
      final int recommendedFee = (transAmount / 1000000).ceil();
      if(int.parse(amount) == recommendedFee) return null;
      return "Recommended for security: $recommendedFee";
    }
    return "Min fee: ${currency.minFee} - transaction might not work";
  }

  String? _getMaxBlockHeightHelper(String height, String prefix) {
    if (int.tryParse(height) == null) return null;
    final List<Currency> currencies =
        BlocProvider.of<CurrenciesAndTradesCubit>(context).state.currencies!;
    final Currency currency =
        currencies.firstWhere((element) => element.addressPrefix == prefix);
    if (int.parse(height) <= currency.defaultMaxBlockHeight) return null;
    return "Default: ${currency.defaultMaxBlockHeight} - be careful!";
  }

  String? _getMinConfirmationHeightHelper(String height, String prefix) {
    if (int.tryParse(height) == null) return null;
    final List<Currency> currencies =
        BlocProvider.of<CurrenciesAndTradesCubit>(context).state.currencies!;
    final Currency currency =
        currencies.firstWhere((element) => element.addressPrefix == prefix);
    if (int.parse(height) >= currency.defaultMinConfirmationHeight) return null;
    return "Default: ${currency.defaultMinConfirmationHeight} - be careful!";
  }

  @override
  void dispose() {
    _idController.dispose();
    _feeController.dispose();
    _maxBlockHeightController.dispose();
    _minConfirmationHeightController.dispose();
    _fromAddressController.dispose();
    _toAddressController.dispose();
    _totalAmountController.dispose();
    super.dispose();
  }
}
