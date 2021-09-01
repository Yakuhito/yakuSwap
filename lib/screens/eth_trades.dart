import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yakuswap/cubits/eth/cubit.dart';
import 'package:yakuswap/models/eth_trade.dart';
import 'package:yakuswap/screens/eth_trade.dart';

class EthTrades extends StatelessWidget {
  const EthTrades({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EthCubit, EthState>(
      builder: (context, state) {
        if(state.status == EthStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.status == EthStatus.loadError) {
          return const Center(
            child: Text('Error :('),
          );
        }
        if(!state.walletConnected) {
          return Center(
            child: ElevatedButton(
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Connect with MetaMask", style: TextStyle(color: Colors.white)),
              ),
              onPressed: () => BlocProvider.of<EthCubit>(context).refresh(connectWallet: true),
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableText(
                "Connected address:\n${state.address}",
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              const Divider(height: 32.0),
              _EthTradesList(trades: state.trades),
            ],
          ),
        );
      }
    );
  }
}

class _EthTradesList extends StatelessWidget {
  final List<EthTrade>? trades;

  const _EthTradesList({ required this.trades, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(trades == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: trades!.length + 1,
      itemBuilder: (context, index) {
        if(index == trades!.length) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: OutlinedButton.icon(
              label: const Text('Add new trade'),
              icon: const Icon(Icons.add),
              onPressed: () async {
                    final dynamic result = await Navigator.of(context).push(MaterialPageRoute(
                     builder: (context) => const EthTradeScreen(),
                    ));
                    
                    if(result != null && result is EthTrade) {
                      final EthTrade t = result;
                      BlocProvider.of<EthCubit>(context).updateTrade(trade: t);
                    }
              },
            ),
          );
        }
        return _TradeTile(trade: trades![index]);
      },
    );
  }
}

class _TradeTile extends StatelessWidget {
  final EthTrade trade;

  const _TradeTile({ required this.trade, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}