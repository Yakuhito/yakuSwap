import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yakuswap/cubits/currency/cubit.dart';
import 'package:yakuswap/models/currency.dart';
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

class CurrencyScreen extends StatelessWidget {
  final Currency? currency;

  const CurrencyScreen({this.currency, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currency != null ? "Edit currency" : "New currency"),
        centerTitle: true,
      ),
      body: BlocProvider<CurrencyCubit>(
        create: (context) => CurrencyCubit(currency: currency),
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 3.0,
            child: _Body(
              showDeleteButton: currency != null,
            ),
          ),
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
  bool initialized = false;

  final TextEditingController _addressPrefixController =
      TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _photoURLController = TextEditingController();

  final TextEditingController _unitsPerCoinController = TextEditingController();

  final TextEditingController _minFeeController = TextEditingController();

  final TextEditingController _defaultMaxBlockHeightController =
      TextEditingController();

  final TextEditingController _defaultMinConfirmationHeightController =
      TextEditingController();

  final TextEditingController _hostController = TextEditingController();

  final TextEditingController _portController = TextEditingController();

  final TextEditingController _sslDirectoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrencyCubit, CurrencyState>(
      builder: (context, state) {
        if(!initialized) {
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            setState(() {
              initialized = true;
              BlocProvider.of<CurrencyCubit>(context).emitForceReload();
            });
          });
        }
    
        return SingleChildScrollView(
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
                    final String exportString =
                        BlocProvider.of<CurrencyCubit>(context).export();
                    await Clipboard.setData(ClipboardData(text: exportString));
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                            content: Text("Currency data copied to clipboard")),
                      );
                  },
                ),
                const SizedBox(height: 8.0),
                OutlinedButton.icon(
                  icon: const Icon(Icons.arrow_circle_down_outlined),
                  label: const Text("Import"),
                  onPressed: () async {
                    final ClipboardData? clipboardData =
                        await Clipboard.getData("text/plain");
                    final String importStr = clipboardData?.text ?? "";
                    String message = "";

                    if (importStr.isNotEmpty) {
                      message = BlocProvider.of<CurrencyCubit>(context)
                          .import(importStr);
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 5,
                      child: TextFormField(
                        controller: _addressPrefixController,
                        decoration: InputDecoration(
                          labelText: AddressPrefixInput.labelText,
                          hintText: AddressPrefixInput.hintText,
                          errorText: state.form.addressPrefix.pure
                              ? null
                              : state.form.addressPrefix.error,
                        ),
                        onChanged: (newVal) =>
                            BlocProvider.of<CurrencyCubit>(context)
                                .changeAddressPrefix(newVal),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Flexible(
                      flex: 6,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: NameInput.labelText,
                          hintText: NameInput.hintText,
                          errorText: state.form.name.pure
                              ? null
                              : state.form.name.error,
                        ),
                        onChanged: (newVal) =>
                            BlocProvider.of<CurrencyCubit>(context)
                                .changeName(newVal),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _photoURLController,
                  decoration: InputDecoration(
                    labelText: PhotoURLInput.labelText,
                    hintText: PhotoURLInput.hintText,
                    errorText: state.form.photoURL.pure
                        ? null
                        : state.form.photoURL.error,
                  ),
                  onChanged: (newVal) => BlocProvider.of<CurrencyCubit>(context)
                      .changePhotoURL(newVal),
                ),
                const SizedBox(height: 8.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 5,
                      child: TextFormField(
                        controller: _unitsPerCoinController,
                        decoration: InputDecoration(
                          labelText: UnitsPerCoinInput.labelText,
                          hintText: UnitsPerCoinInput.hintText,
                          errorText: state.form.unitsPerCoin.pure
                              ? null
                              : state.form.unitsPerCoin.error,
                        ),
                        onChanged: (newVal) =>
                            BlocProvider.of<CurrencyCubit>(context)
                                .changeUnitsPerCoin(newVal),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        controller: _minFeeController,
                        decoration: InputDecoration(
                          labelText: FeeInput.labelText + " (min)",
                          hintText: FeeInput.hintText,
                          errorText: state.form.minFee.pure
                              ? null
                              : state.form.minFee.error,
                        ),
                        onChanged: (newVal) =>
                            BlocProvider.of<CurrencyCubit>(context)
                                .changeMinFee(newVal),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        controller: _defaultMaxBlockHeightController,
                        decoration: InputDecoration(
                          labelText:
                              "${MaxBlockHeightInput.labelText} (default)",
                          hintText: MaxBlockHeightInput.hintText,
                          errorText: state.form.defaultMaxBlockHeight.pure
                              ? null
                              : state.form.defaultMaxBlockHeight.error,
                        ),
                        onChanged: (newVal) =>
                            BlocProvider.of<CurrencyCubit>(context)
                                .changeDefaultMaxBlockHeight(newVal),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        controller: _defaultMinConfirmationHeightController,
                        decoration: InputDecoration(
                          labelText:
                              "${MinConfirmationHeightInput.labelText} (default)",
                          hintText: MinConfirmationHeightInput.hintText,
                          errorText: state
                                  .form.defaultMinConfirmationHeight.pure
                              ? null
                              : state.form.defaultMinConfirmationHeight.error,
                        ),
                        onChanged: (newVal) =>
                            BlocProvider.of<CurrencyCubit>(context)
                                .changeDefaultMinConfirmationHeight(newVal),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 4,
                      child: TextFormField(
                        controller: _hostController,
                        decoration: InputDecoration(
                          labelText: HostInput.labelText,
                          hintText: HostInput.hintText,
                          errorText: state.form.host.pure
                              ? null
                              : state.form.host.error,
                        ),
                        onChanged: (newVal) =>
                            BlocProvider.of<CurrencyCubit>(context)
                                .changeHost(newVal),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        controller: _portController,
                        decoration: InputDecoration(
                          labelText: PortInput.labelText,
                          hintText: PortInput.hintText,
                          errorText: state.form.port.pure
                              ? null
                              : state.form.port.error,
                        ),
                        onChanged: (newVal) =>
                            BlocProvider.of<CurrencyCubit>(context)
                                .changePort(newVal),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _sslDirectoryController,
                  decoration: InputDecoration(
                    labelText: DirectoryInput.labelText,
                    hintText: DirectoryInput.hintText,
                    errorText:
                        state.form.sslDirectory.pure ? null : state.form.sslDirectory.error,
                  ),
                  onChanged: (newVal) => BlocProvider.of<CurrencyCubit>(context)
                      .changeSslDirectory(newVal),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  child: const Text("Save"),
                  onPressed: state.canSubmit
                      ? () {
                          final Currency? c = state.form.toCurrency();
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
                                    title: const Text("Are you sure?"),
                                    content: const Text(
                                        "Do you really want to delete this currency?"),
                                    actions: [
                                      TextButton(
                                        child: const Text("Cancel"),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                      TextButton(
                                        child: const Text("DELETE"),
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
        );
      },
      listenWhen: (oldState, newState) => newState.forceReload == true,
      listener: (context, state) => _updateFormFields(context, state),
    );
  }

  void _updateFormFields(BuildContext context, CurrencyState state) {
    _addressPrefixController.text = state.form.addressPrefix.value;
    _nameController.text = state.form.name.value;
    _photoURLController.text = state.form.photoURL.value;
    _unitsPerCoinController.text = state.form.unitsPerCoin.value;
    _minFeeController.text = state.form.minFee.value.toString();
    _defaultMaxBlockHeightController.text =
        state.form.defaultMaxBlockHeight.value.toString();
    _defaultMinConfirmationHeightController.text =
        state.form.defaultMinConfirmationHeight.value.toString();
    _hostController.text = state.form.host.value;
    _portController.text = state.form.port.value.toString();
    _sslDirectoryController.text = state.form.sslDirectory.value;
  }

  @override
  void dispose() {
    _addressPrefixController.dispose();
    _nameController.dispose();
    _photoURLController.dispose();
    _unitsPerCoinController.dispose();
    _minFeeController.dispose();
    _defaultMaxBlockHeightController.dispose();
    _defaultMinConfirmationHeightController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _sslDirectoryController.dispose();
    super.dispose();
  }
}
