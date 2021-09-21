import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yakuswap/cubits/currencies_and_trades/cubit.dart';
import 'package:yakuswap/cubits/eth/cubit.dart';
import 'package:yakuswap/models/currency.dart';
import 'package:yakuswap/models/eth_trade.dart';
import 'package:yakuswap/screens/eth_trade.dart';
import 'package:yakuswap/screens/trade_status.dart';

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
              const SizedBox(height: 16.0),
              Text(
                "WARNING: Each party of an ETH swap will be required to make a transaction and pay the fee. Make sure you have enought ETH to make the transaction!",
                style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.red),
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
    final List<Currency> currencies = BlocProvider.of<CurrenciesAndTradesCubit>(context).state.currencies!;
    final Currency currency = currencies.firstWhere((element) => element.addressPrefix == trade.tradeCurrency.addressPrefix);
    const String ethUrl = "https://raw.githubusercontent.com/ethereum/ethereum-org-website/dev/src/assets/assets/eth-diamond-black-white.svg";
    final String url1 = trade.isBuyer ? currency.photoUrl : ethUrl;
    final String url2 = trade.isBuyer ? ethUrl : currency.photoUrl;
    
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
                aspectRatio: 1.0,
                child: Center(child: url1.endsWith(".svg")? SvgPicture.network(url1) : Image.network(url1))
            ),
            const Icon(Icons.swap_horiz),
            AspectRatio(
                aspectRatio: 1.0,
                child: Center(child: url2.endsWith(".svg")? SvgPicture.network(url2) : Image.network(url2))
            ),
          ],
        ),
        title: Text("${trade.tradeCurrency.totalAmount / currency.unitsPerCoin} XCH for ${trade.totalGwei / 1000000000} ETH"),
        subtitle: Text("${trade.id}\n" + (trade.isBuyer ? "Initiated by you" : "Initiated by someone else")),
        isThreeLine: true,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey[400]!, width: 1),
            borderRadius: BorderRadius.circular(18.0),
          ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () async {
            final dynamic result = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EthTradeScreen(trade: trade),
            ));

            if(result != null && result is EthTrade) {
              final EthTrade t = result;
              BlocProvider.of<EthCubit>(context).updateTrade(trade: t);
            } else if(result == true) {
              BlocProvider.of<EthCubit>(context).deleteTrade(id: trade.id);
            }
          },
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TradeStatusScreen(
              tradeId: trade.id,
              ethTrade: true,
            ),
          ));
        },
      ),
    );
  }
}