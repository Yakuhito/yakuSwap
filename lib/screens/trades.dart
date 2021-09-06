import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yakuswap/cubits/currencies_and_trades/cubit.dart';
import 'package:yakuswap/models/currency.dart';
import 'package:yakuswap/models/trade.dart';
import 'package:yakuswap/screens/trade.dart';
import 'package:yakuswap/screens/trade_simple.dart';
import 'package:yakuswap/screens/trade_status.dart';

class TradesScreen extends StatelessWidget {
  const TradesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrenciesAndTradesCubit, CurrenciesAndTradesState>(
      buildWhen: (oldState, newState) =>
          oldState.status != newState.status ||
          oldState.trades != newState.trades,
      builder: (context, state) {
        if (state.status == CurrenciesAndTradesStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.status == CurrenciesAndTradesStatus.loadError) {
          return const Center(
            child: Text('Error while fetching trades. Is the server running?'),
          );
        }
        return ListView.builder(
          itemCount: state.trades!.length + 2,
          itemBuilder: (context, index) {
            if(index == state.trades!.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: OutlinedButton.icon(
                  label: const Text('Add new trade'),
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    final dynamic result = await Navigator.of(context).push(MaterialPageRoute(
                     builder: (context) => const TradeSimpleScreen(),
                    ));
                    
                    if(result != null && result is Trade) {
                      final Trade t = result;
                      BlocProvider.of<CurrenciesAndTradesCubit>(context).updateTrade(newTrade: t);
                    }
                  },
                ),
              );
            }
            if(index == state.trades!.length + 1) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                child: OutlinedButton.icon(
                  label: const Text('Create new trade (advanced)'),
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    final dynamic result = await Navigator.of(context).push(MaterialPageRoute(
                     builder: (context) => const TradeScreen(),
                    ));
                    
                    if(result != null && result is Trade) {
                      final Trade t = result;
                      BlocProvider.of<CurrenciesAndTradesCubit>(context).updateTrade(newTrade: t);
                    }
                  },
                ),
              );
            }
            return _TradeTile(trade: state.trades![index]);
          },
        );
      },
    );
  }
}

class _TradeTile extends StatelessWidget {
  final Trade trade;

  const _TradeTile({ required this.trade, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Currency> currencies = BlocProvider.of<CurrenciesAndTradesCubit>(context).state.currencies!;
    final Currency currencyOne = currencies.firstWhere((element) => element.addressPrefix == trade.tradeCurrencyOne.addressPrefix);
    final Currency currencyTwo = currencies.firstWhere((element) => element.addressPrefix == trade.tradeCurrencyTwo.addressPrefix);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
                aspectRatio: 1.0,
                child:  Center(child: currencyOne.photoUrl.endsWith(".svg")? SvgPicture.network(currencyOne.photoUrl) : Image.network(currencyOne.photoUrl))
            ),
            const Icon(Icons.swap_horiz),
            AspectRatio(
                aspectRatio: 1.0,
                child:  Center(child: currencyTwo.photoUrl.endsWith(".svg")? SvgPicture.network(currencyTwo.photoUrl) : Image.network(currencyTwo.photoUrl))
            ),
          ],
        ),
        title: Text("${trade.tradeCurrencyOne.totalAmount / currencyOne.unitsPerCoin} ${currencyOne.addressPrefix.toUpperCase()} for ${trade.tradeCurrencyTwo.totalAmount / currencyTwo.unitsPerCoin} ${currencyTwo.addressPrefix.toUpperCase()} "),
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
              builder: (context) => TradeScreen(trade: trade),
            ));

            if(result != null && result is Trade) {
              final Trade t = result;
              BlocProvider.of<CurrenciesAndTradesCubit>(context).updateTrade(newTrade: t);
            } else if(result == true) {
              BlocProvider.of<CurrenciesAndTradesCubit>(context).deleteTrade(id: trade.id);
            }
          },
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TradeStatusScreen(tradeId: trade.id),
          ));
        },
      ),
    );
  }
}