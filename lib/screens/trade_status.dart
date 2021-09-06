import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:yakuswap/cubits/eth/cubit.dart';
import 'package:yakuswap/cubits/trade_status/cubit.dart';
import 'package:yakuswap/models/command.dart';
import 'package:yakuswap/repositories/allinone.dart';

class TradeStatusScreen extends StatelessWidget {
  final String tradeId;
  final bool ethTrade;

  const TradeStatusScreen({required this.tradeId, this.ethTrade = false, key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TradeStatusCubit>(
      create: (context) => TradeStatusCubit(
        tradeId: tradeId,
        allInOneRepository: RepositoryProvider.of<AllInOneRepository>(context),
        ethTrade: ethTrade,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(tradeId),
          centerTitle: true,
        ),
        body: Builder(
          builder: (context) => BlocConsumer<TradeStatusCubit, TradeStatusState>(
            listenWhen: (oldState, newState) => newState.tradeStatus.command != oldState.tradeStatus.command && newState.tradeStatus.command?.type == CommandType.waitForSwap,
            listener: (context, state) {
              BlocProvider.of<EthCubit>(context).handleCommand(
                tradeId: tradeId,
                command: state.tradeStatus.command!,
                showMessage: (message) => ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(message))),
              );
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Trade Status",
                          style: Theme.of(context).textTheme.headline3,
                          textAlign: TextAlign.center,
                        ),
                        Flexible(
                          child: Center(
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: LoadingIndicator(
                                indicatorType: Indicator.pacman,
                                colors: const [Colors.yellow, Colors.red, Colors.red],
                                backgroundColor: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SelectableText(
                                  state.tradeStatus.message,
                                  style: Theme.of(context).textTheme.headline4,
                                  textAlign: TextAlign.center,
                                ),
                                state.tradeStatus.address == null
                                    ? const SizedBox.shrink()
                                    : Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SelectableText(
                                            state.tradeStatus.address!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 8.0),
                                          IconButton(
                                            icon: const Icon(Icons.copy),
                                            onPressed: () async {
                                              await Clipboard.setData(ClipboardData(
                                                  text:
                                                      state.tradeStatus.address!));
                                              ScaffoldMessenger.of(context)
                                                ..hideCurrentSnackBar()
                                                ..showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Address copied to clipboard!"),
                                                ));
                                            },
                                          ),
                                        ],
                                      ),
                                _getButtonForCommand(context, state.tradeId, state.tradeStatus.command),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _getButtonForCommand(BuildContext context, String tradeId, Command? command) {
    if(command == null) return const SizedBox.shrink();

    String message = command.type == CommandType.createSwap ? "Create swap" : (command.type == CommandType.completeSwap ? "Complete swap" : "Cancel swap");
    switch(command.type) {
      case CommandType.createSwap:
      case CommandType.completeSwap:
      case CommandType.cancelSwap:
        return Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
            onPressed: () => BlocProvider.of<EthCubit>(context).handleCommand(
              tradeId: tradeId,
              command: command,
              showMessage: (message) => ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(message))),
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
