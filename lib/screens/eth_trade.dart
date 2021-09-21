import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yakuswap/cubits/eth/cubit.dart';
import 'package:yakuswap/cubits/eth_trade/cubit.dart';
import 'package:yakuswap/models/eth_trade.dart';
import 'package:yakuswap/models/forms/eth_trade.dart';
import 'package:yakuswap/models/inputs/address.dart';
import 'package:yakuswap/models/inputs/eth_adress.dart';
import 'package:yakuswap/models/inputs/hash.dart';
import 'package:yakuswap/models/inputs/transaction_amount.dart';

class EthTradeScreen extends StatelessWidget {
  final EthTrade? trade;

  const EthTradeScreen({this.trade, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EthTradeCubit>(
      create: (context) => EthTradeCubit(trade: trade),
      child: _Screen(showDeleteButton: trade != null),
    );
  }
}

class _Screen extends StatelessWidget {
  final bool showDeleteButton;

  const _Screen({ required this.showDeleteButton, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EthTradeCubit, EthTradeState>(
      builder: (context, state) {
        if(state.form.id.pure) {
          return Container();
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(state.form.id.value),
            centerTitle: true,
          ),
          body: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 3.0,
              child: _Body(
                form: state.form,
                showDeleteButton: showDeleteButton,
                canSubmit: state.canSubmit,
                warning: state.warning,
              ),
            ),
          ),
        );
      }
    );
  }
}

class _Body extends StatefulWidget {
  final bool showDeleteButton;
  final bool canSubmit;
  final EthTradeForm form;
  final String? warning;

  const _Body({
    required this.form,
    this.showDeleteButton = false,
    this.canSubmit = false,
    this.warning,
    Key? key
  }) : super(key: key);

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  late final TextEditingController _xchYourAddressController;
  late final TextEditingController _xchPartnerAddressController;
  late final TextEditingController _xchTotalAmountController;
  late final TextEditingController _ethYourAddressController;
  late final TextEditingController _ethPartnerAddressController;
  late final TextEditingController _ethTotalAmountController;
  late final TextEditingController _secretHashController;

  @override
  void initState() {
    _xchTotalAmountController = TextEditingController(text: widget.form.tradeCurrency.totalAmount.value);
    _ethTotalAmountController = TextEditingController(text: widget.form.ethTotalGwei.value);
    _secretHashController = TextEditingController(text: widget.form.secretHash.value);
    if(!widget.form.isBuyer) {
      _ethYourAddressController = TextEditingController(text: widget.form.ethToAddress.value);
      _ethPartnerAddressController = TextEditingController(text: widget.form.ethFromAddress.value);
      _xchYourAddressController = TextEditingController(text: widget.form.tradeCurrency.fromAddress.value);
      _xchPartnerAddressController = TextEditingController(text: widget.form.tradeCurrency.toAddress.value);
    } else {
      _ethYourAddressController = TextEditingController(text: widget.form.ethFromAddress.value);
      _ethPartnerAddressController = TextEditingController(text: widget.form.ethToAddress.value);
      _xchYourAddressController = TextEditingController(text: widget.form.tradeCurrency.toAddress.value);
      _xchPartnerAddressController = TextEditingController(text: widget.form.tradeCurrency.fromAddress.value);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AddressInput xchAddress1 = widget.form.isBuyer ? widget.form.tradeCurrency.toAddress : widget.form.tradeCurrency.fromAddress;
    AddressInput xchAddress2 = widget.form.isBuyer ? widget.form.tradeCurrency.fromAddress : widget.form.tradeCurrency.toAddress;
    EthAddressInput ethAddress1 = widget.form.isBuyer ? widget.form.ethFromAddress : widget.form.ethToAddress;
    EthAddressInput ethAddress2 = widget.form.isBuyer ? widget.form.ethToAddress : widget.form.ethFromAddress;
    
    return BlocListener<EthTradeCubit, EthTradeState>(
      listenWhen: (oldState, newState) => newState.forceReload == true,
      listener: (context, state) {
        _xchTotalAmountController.text = state.form.tradeCurrency.totalAmount.value;
        _ethTotalAmountController.text = state.form.ethTotalGwei.value;
        _secretHashController.text = state.form.secretHash.value;
        if(!state.form.isBuyer) {
          _ethYourAddressController.text = state.form.ethToAddress.value;
          _ethPartnerAddressController.text = state.form.ethFromAddress.value;
          _xchYourAddressController.text = state.form.tradeCurrency.fromAddress.value;
          _xchPartnerAddressController.text = state.form.tradeCurrency.toAddress.value;
        } else {
          _ethYourAddressController.text = state.form.ethFromAddress.value;
          _ethPartnerAddressController.text = state.form.ethToAddress.value;
          _xchYourAddressController.text = state.form.tradeCurrency.toAddress.value;
          _xchPartnerAddressController.text = state.form.tradeCurrency.fromAddress.value;
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24.0,
            horizontal: 12.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.arrow_circle_up_outlined),
                label: const Text("Export"),
                onPressed: () async {
                  final String exportString = BlocProvider.of<EthTradeCubit>(context).export();
                  await Clipboard.setData(ClipboardData(text: exportString));
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                       const SnackBar(content: Text(
                        "Trade data copied to clipboard - the export contains your SECRET, so DO NOT SHARE IT WITH ANYBODY!")
                        ),
                    );
                },
              ),
              const SizedBox(height: 8.0),
              OutlinedButton.icon(
                icon: const Icon(Icons.arrow_circle_down_outlined),
                label: const Text("Import"),
                onPressed: () async {
                  final ClipboardData? clipboardData = await Clipboard.getData("text/plain");
                  final String importStr = clipboardData?.text ?? "";
                  String message = "";

                  if (importStr.isNotEmpty) {
                    message = BlocProvider.of<EthTradeCubit>(context).import(importStr);
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
                icon: const Icon(Icons.share),
                label: const Text("Share"),
                onPressed: () async {
                  final String exportString = BlocProvider.of<EthTradeCubit>(context).safeExport();
                  await Clipboard.setData(ClipboardData(text: exportString));
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(const SnackBar(content: Text(
                        "Data copied to clipboard - you can share it with your trade partner")
                      ),
                    );
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<bool>(
                key: Key("ethTrade_isBuyer_${widget.form.isBuyer}"),
                value: widget.form.isBuyer,
                onChanged: (newVal) => BlocProvider.of<EthTradeCubit>(context).changeIsBuyer(newVal ?? true),
                items: [
                  DropdownMenuItem<bool>(
                    value: true,
                    child: Text(
                      "I want to buy XCH with ETH",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  DropdownMenuItem<bool>(
                    value: false,
                    child: Text(
                      "I want to buy ETH with XCH",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              TextFormField(
                controller: _xchYourAddressController,
                decoration: InputDecoration(
                  labelText: "Your XCH address",
                  hintText: AddressInput.hintText,
                  errorText: xchAddress1.pure ? null : xchAddress1.error,
                ),
                onChanged: (newVal) {
                  if(widget.form.isBuyer) {
                    BlocProvider.of<EthTradeCubit>(context).changeTradeCurrency(widget.form.tradeCurrency.copyWith(
                      toAddress: AddressInput.dirty(value: newVal),
                    ));
                  } else {
                    BlocProvider.of<EthTradeCubit>(context).changeTradeCurrency(widget.form.tradeCurrency.copyWith(
                      fromAddress: AddressInput.dirty(value: newVal),
                    ));
                  }
                },
              ),
              const SizedBox(height: 16.0),
               TextFormField(
                controller: _xchPartnerAddressController,
                decoration: InputDecoration(
                  labelText: "Your partner's XCH address",
                  hintText: AddressInput.hintText,
                  errorText: xchAddress2.pure ? null : xchAddress2.error,
                ),
                onChanged: (newVal) {
                  if(widget.form.isBuyer) {
                    BlocProvider.of<EthTradeCubit>(context).changeTradeCurrency(widget.form.tradeCurrency.copyWith(
                      fromAddress: AddressInput.dirty(value: newVal),
                    ));
                  } else {
                    BlocProvider.of<EthTradeCubit>(context).changeTradeCurrency(widget.form.tradeCurrency.copyWith(
                      toAddress: AddressInput.dirty(value: newVal),
                    ));
                  }
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _xchTotalAmountController,
                decoration: InputDecoration(
                  labelText: "XCH Amount (in mojo)",
                  hintText: TransactionAmountInput.hintText,
                  errorText: widget.form.tradeCurrency.totalAmount.pure ? null : widget.form.tradeCurrency.totalAmount.error,
                  helperText: _getAmountHelper(
                    widget.form.tradeCurrency.totalAmount.value, "XCH", 1000000000000
                  ),
                ),
                onChanged: (newVal) => BlocProvider.of<EthTradeCubit>(context).changeTradeCurrency(widget.form.tradeCurrency.copyWith(
                  totalAmount: TransactionAmountInput.dirty(value: newVal),
                )),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _ethYourAddressController,
                decoration: InputDecoration(
                  labelText: "Your ETH address",
                  hintText: EthAddressInput.hintText,
                  errorText: ethAddress1.pure ? null : ethAddress1.error,
                ),
                onChanged: (newVal) {
                  if(widget.form.isBuyer) {
                    BlocProvider.of<EthTradeCubit>(context).changeEthFromAddress(newVal);
                  } else {
                    BlocProvider.of<EthTradeCubit>(context).changeEthToAddress(newVal);
                  }
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _ethPartnerAddressController,
                decoration: InputDecoration(
                  labelText: "Your partner's ETH address",
                  hintText: EthAddressInput.hintText,
                  errorText: ethAddress2.pure ? null : ethAddress2.error,
                ),
                onChanged: (newVal) {
                  if(widget.form.isBuyer) {
                    BlocProvider.of<EthTradeCubit>(context).changeEthToAddress(newVal);
                  } else {
                    BlocProvider.of<EthTradeCubit>(context).changeEthFromAddress(newVal);
                  }
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _ethTotalAmountController,
                decoration: InputDecoration(
                  labelText: "ETH Amount (in gwei)",
                  hintText: TransactionAmountInput.hintText,
                  errorText: widget.form.ethTotalGwei.pure ? null : widget.form.ethTotalGwei.error,
                  helperText: _getAmountHelper(
                    widget.form.ethTotalGwei.value, "ETH", 1000000000, showFee: false
                  ),
                ),
                onChanged: (newVal) => BlocProvider.of<EthTradeCubit>(context).changeEthTotalWei(newVal),
              ),
              widget.form.isBuyer ? const SizedBox.shrink() :
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextFormField(
                  controller: _secretHashController,
                  decoration: InputDecoration(
                    labelText: "Secret hash (from partner)",
                    hintText: HashInput.hintText,
                    errorText: widget.form.secretHash.pure ? null : widget.form.secretHash.error,
                  ),
                  onChanged: (newVal) => BlocProvider.of<EthTradeCubit>(context).changeSecretHash(newVal),
                ),
              ), 
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                key: Key("ethTrade_network_${widget.form.network}"),
                value: widget.form.network,
                onChanged: (newVal) => BlocProvider.of<EthTradeCubit>(context).changeNetwork(
                  newVal ?? "Rinkeby Testnet",
                  newVal == null ? "WETH" : BlocProvider.of<EthCubit>(context).state.networks!.firstWhere((element) => element.name == newVal).tokenAddresses.keys.first,
                ),
                items: BlocProvider.of<EthCubit>(context).state.networks!.map(
                  (network) => DropdownMenuItem<String>(
                    value: network.name,
                    child: Text(
                      network.name,
                    ),
                  ),
                ).toList(),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                key: Key("ethTrade_token_${widget.form.token}"),
                value: widget.form.token,
                onChanged: (newVal) => BlocProvider.of<EthTradeCubit>(context).changeToken(newVal ?? "WETH"),
                items: BlocProvider.of<EthCubit>(context).state.networks!.firstWhere((e) => e.name == widget.form.network).tokenAddresses.keys.map(
                  (token) => DropdownMenuItem<String>(
                    value: token,
                    child: Text(
                      token,
                    ),
                  ),
                ).toList(),
              ),
              const SizedBox(height: 16.0),
              widget.warning != null ? Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  widget.warning!,
                  style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.red),
                ),
              ) : const SizedBox.shrink(),
              ElevatedButton(
                child: const Text("Save"),
                onPressed: widget.canSubmit ? () {
                  final EthTrade? res = widget.form.toTrade();
                  Navigator.of(context).pop(res);
                } : null,
              ),
              const SizedBox(height: 8.0),
              widget.showDeleteButton ? ElevatedButton(
                child: const Text("Delete"),
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: widget.canSubmit ? () async {
                  final dynamic confirm = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Are you sure?"),
                      content: const Text("Do you really want to delete this trade?"),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: const Text("DELETE"),
                          style: TextButton.styleFrom(primary: Colors.red),
                          onPressed: () => Navigator.of(context).pop(true)
                        ),
                      ],
                    ),
                  );
                  Navigator.of(context).pop(confirm);
                } : null,
              ) : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  String? _getAmountHelper(String amount, String symbol, int unitsPerCoin, {bool showFee = true}) {
    if (int.tryParse(amount) == null) return null;
    
    int amnt = int.parse(amount);
    final int units = (amnt / unitsPerCoin).floor();
    String s = "$units.";
    amnt = amnt - units * unitsPerCoin;
    bool amntModified = amnt == 0;
    if(amntModified) amnt = 1;
    for(int pow = 1; pow * 10 * amnt < unitsPerCoin; pow *= 10) {
      s += "0";
    }
    if(amntModified) {
      s += "0 $symbol ";
    } else {
      s += "$amnt $symbol ";
    }
    if(showFee) {
      double feeAmnt = ((int.parse(amount) * 75 / 10000).ceil() + 2) / unitsPerCoin;
      s += "(max fee: $feeAmnt)";
    } else {
      s += "(does not include transaction fees)";
    }
    return s;
  }

  @override
  void dispose() {
    _xchYourAddressController.dispose();
    _xchPartnerAddressController.dispose();
    _xchTotalAmountController.dispose();
    _ethYourAddressController.dispose();
    _ethPartnerAddressController.dispose(); 
    _ethTotalAmountController.dispose(); 
    _secretHashController.dispose();
    super.dispose();
  }
}
