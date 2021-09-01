import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yakuswap/cubits/currencies_and_trades/cubit.dart';
import 'package:yakuswap/models/currency.dart';
import 'package:yakuswap/models/full_node_connection.dart';
import 'package:yakuswap/screens/currency.dart';

class CurrenciesScreen extends StatelessWidget {
  const CurrenciesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrenciesAndTradesCubit, CurrenciesAndTradesState>(
      buildWhen: (oldState, newState) =>
          oldState.status != newState.status ||
          oldState.currencies != newState.currencies ||
          oldState.connections != newState.connections,
      builder: (context, state) {
        if (state.status == CurrenciesAndTradesStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.status == CurrenciesAndTradesStatus.loadError) {
          return const Center(
            child: Text('Error while fetching currencies. Is the server running?'),
          );
        }
        return ListView.builder(
          itemCount: state.currencies!.length + 1,
          itemBuilder: (context, index) {
            if(index == state.currencies!.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                child: OutlinedButton.icon(
                  label: const Text('Add new currency'),
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    final dynamic result = await Navigator.of(context).push(MaterialPageRoute(
                     builder: (context) => const CurrencyScreen(),
                    ));
                    
                    if(result != null && result is Currency) {
                      final Currency c = result;
                      BlocProvider.of<CurrenciesAndTradesCubit>(context).updateCurrency(newCurrency: c);
                    }
                  },
                ),
              );
            }
            return _CurrencyTile(
              currency: state.currencies![index],
              connection: state.connections?.firstWhere((element) => element.currency == state.currencies![index].addressPrefix),
            );
          },
        );
      },
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  final Currency currency;
  final FullNodeConnection? connection;

  const _CurrencyTile({ required this.currency, this.connection, Key? key }) : super(key: key);

  Color _getStatusColor() {
    switch(connection?.status) {
      case null:
        return Colors.white;
      case FullNodeConnectionStatus.connected:
        return Colors.green;
      case FullNodeConnectionStatus.notSynced:
        return Colors.orange;
      case FullNodeConnectionStatus.notConnected:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: AspectRatio(
          aspectRatio: 1.0,
          child: Center(child: currency.photoUrl.endsWith(".svg")? SvgPicture.network(currency.photoUrl) : Image.network(currency.photoUrl))
        ),
        title: Text("${currency.name} (${currency.addressPrefix.toUpperCase()})"),
        subtitle: Text("${currency.host}:${currency.port}"),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[400]!, width: 1),
          borderRadius: BorderRadius.circular(18.0),
        ),
        onTap: () async {
          final dynamic result = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CurrencyScreen(currency: currency),
          ));
          
          if(result != null && result is Currency) {
            final Currency c = result;
            BlocProvider.of<CurrenciesAndTradesCubit>(context).updateCurrency(newCurrency: c);
          } else if(result == true) {
            BlocProvider.of<CurrenciesAndTradesCubit>(context).deleteCurrency(addressPrefix: currency.addressPrefix);
          }
        },
        trailing: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxHeight * 0.33,
              height: constraints.maxHeight * 0.33,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getStatusColor(),
              ),
            );
          }
        ),
      ),
    );
  }
}
