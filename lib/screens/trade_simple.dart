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
import 'package:yakuswap/models/inputs/max_block_height.dart';
import 'package:yakuswap/models/inputs/min_confirmation_height.dart';
import 'package:yakuswap/models/inputs/transaction_amount.dart';
import 'package:yakuswap/models/trade.dart';

class TradeSimpleScreen extends StatelessWidget {
  final Trade? trade;

  const TradeSimpleScreen({this.trade, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New trade"),
        centerTitle: true,
      ),
      body: BlocProvider<TradeCubit>(
        create: (context) => TradeCubit(trade: trade),
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 3.0,
            child: _Body(),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({ Key? key }) : super(key: key);

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  bool isBuyer = true;

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
              const SizedBox(height: 16.0),
              DropdownButtonFormField<bool>(
                  key: Key("tradeSimple_isBuyer_${isBuyer}"),
                  value: isBuyer,
                  onChanged: (newVal) => setState(() => isBuyer = newVal ?? true),
                  items: [
                    DropdownMenuItem<bool>(
                      value: true,
                      child: Text(
                        "I want to buy a fork coin with XCH",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    DropdownMenuItem<bool>(
                      value: false,
                      child: Text(
                        "I want to buy XCH with a fork coin",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 32.0),
              _TradeCurrencyForm(
                isSender: !isBuyer,
                form: state.form.tradeCurrencyOne,
                onFormChanged: (newForm) => BlocProvider.of<TradeCubit>(context).changeTradeCurrencyOne(newForm),
                locked: false,
              ),
              const SizedBox(height: 32.0),
              _TradeCurrencyForm(
                isSender: isBuyer,
                form: state.form.tradeCurrencyTwo,
                onFormChanged: (newForm) => BlocProvider.of<TradeCubit>(context).changeTradeCurrencyTwo(newForm),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _TradeCurrencyForm extends StatefulWidget {
  final Function(TradeCurrencyForm newForm) onFormChanged;
  final TradeCurrencyForm form;
  final bool isSender;
  final bool locked;

  const _TradeCurrencyForm(
      {required this.onFormChanged,
      required this.form,
      required this.isSender,
      this.locked = true,
      Key? key})
      : super(key: key);

  @override
  __TradeCurrencyFormState createState() => __TradeCurrencyFormState();
}

class __TradeCurrencyFormState extends State<_TradeCurrencyForm> {
  late final TextEditingController _fromAddressController;
  late final TextEditingController _toAddressController;
  late final TextEditingController _totalAmountController;

  @override
  void initState() {
    _fromAddressController =
        TextEditingController(text: widget.form.fromAddress.value);
    _toAddressController =
        TextEditingController(text: widget.form.toAddress.value);
    _totalAmountController =
        TextEditingController(text: widget.form.totalAmount.value);
    widget.onFormChanged(widget.form.copyWith(
      maxBlockHeight: MaxBlockHeightInput.dirty(value: "192"),
      minConfirmationHeight: MinConfirmationHeightInput.dirty(value: "32")
    ));
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
    
    final TextEditingController addrController1 = widget.isSender ? _fromAddressController : _toAddressController;
    final TextEditingController addrController2 = widget.isSender ? _toAddressController : _fromAddressController;
    final AddressInput addrInput1 = widget.isSender ? widget.form.fromAddress : widget.form.toAddress;
    final AddressInput addrInput2 = widget.isSender ? widget.form.toAddress : widget.form.fromAddress;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        widget.locked ? Text(
          widget.form.addressPrefix.value,
          style: Theme.of(context).textTheme.headline5,
        ) : DropdownButtonFormField<String>(
                  key: Key("tradeCurrencyForm_adddressPrefix_${widget.form.addressPrefix.value}"),
                  value: widget.form.addressPrefix.value,
                  onChanged: (newVal) {
                     widget.onFormChanged(widget.form.copyWith(
                       addressPrefix: AddressPrefixInput.dirty(value: newVal!),
                       toAddress: AddressInput.pure(),
                       fromAddress: AddressInput.pure(),
                       totalAmount: TransactionAmountInput.pure(),
                      ));
                      _fromAddressController.clear();
                      _toAddressController.clear();
                      _totalAmountController.clear();
                  },
                  items: currencyPrefixes
                      .map((prefix) => DropdownMenuItem<String>(
                            value: prefix,
                            child: Text(prefix, style: Theme.of(context).textTheme.headline5),
                          ))
                      .toList(),
                ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: addrController1,
          decoration: InputDecoration(
            labelText: "Your ${widget.form.addressPrefix.value.toUpperCase()} address",
            hintText: AddressInput.hintText,
            errorText: addrInput1.pure
                ? null
                : addrInput1.error,
          ),
          onChanged: (newVal) {
            if(widget.isSender)
              widget.onFormChanged(widget.form.copyWith(fromAddress: AddressInput.dirty(value: newVal)));
            else
              widget.onFormChanged(widget.form.copyWith(toAddress: AddressInput.dirty(value: newVal)));
          },
        ),
        TextFormField(
          controller: addrController2,
          decoration: InputDecoration(
            labelText: "Your partner's ${widget.form.addressPrefix.value.toUpperCase()} address",
            hintText: AddressInput.hintText,
            errorText: addrInput2.pure
                ? null
                : addrInput2.error,
          ),
          onChanged: (newVal) {
            if(widget.isSender)
              widget.onFormChanged(widget.form.copyWith(toAddress: AddressInput.dirty(value: newVal)));
            else
              widget.onFormChanged(widget.form.copyWith(fromAddress: AddressInput.dirty(value: newVal)));
          },
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
          onChanged: (newVal) {
            final TransactionAmountInput newInput = TransactionAmountInput.dirty(value: newVal);
            
            if(newInput.valid) {
              final int fee = (int.parse(newVal) / 10000).ceil();
              
              widget.onFormChanged(widget.form.copyWith(
                totalAmount: newInput,
                fee: FeeInput.dirty(value: fee.toString()),
              ));
            } else {
              widget.onFormChanged(widget.form.copyWith(totalAmount: newInput));
            }
            },
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  String? _getAmountHelper(String amount, String prefix) {
    if (int.tryParse(amount) == null) return null;
    final List<Currency> currencies =
        BlocProvider.of<CurrenciesAndTradesCubit>(context).state.currencies!;
    final Currency currency =
        currencies.firstWhere((element) => element.addressPrefix == prefix);
    
    int feeAmnt = (int.parse(amount) * 75 / 10000).ceil() + 2;
    int amnt = int.parse(amount);
    final int units = (amnt / currency.unitsPerCoin).floor();
    String s = "$units.";
    amnt = amnt - units * currency.unitsPerCoin;
    bool amntModified = amnt == 0;
    if(amntModified) amnt = 1;
    for(int pow = 1; pow * amnt * 10 < currency.unitsPerCoin; pow *= 10)
      s += "0";
    if(amntModified)
      s += "0";
    else
      s += "$amnt";
    s += "${currency.addressPrefix.toUpperCase()} (maximum fee: $feeAmnt mojo)";
    return s;
  }

  @override
  void dispose() {
    _fromAddressController.dispose();
    _toAddressController.dispose();
    _totalAmountController.dispose();
    super.dispose();
  }
}
