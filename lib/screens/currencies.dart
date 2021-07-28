import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yakuswap/cubits/currencies_and_trades/cubit.dart';
import 'package:yakuswap/models/currency.dart';
import 'package:yakuswap/screens/currency.dart';

class CurrenciesScreen extends StatelessWidget {
  const CurrenciesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrenciesAndTradesCubit, CurrenciesAndTradesState>(
      buildWhen: (oldState, newState) =>
          oldState.status != newState.status ||
          oldState.currencies != newState.currencies,
      builder: (context, state) {
        if (state.status == CurrenciesAndTradesStatus.loading)
          return Center(
            child: CircularProgressIndicator(),
          );
        if (state.status == CurrenciesAndTradesStatus.load_error)
          return Center(
            child: Text('Error while fetching currencies. Is the server running?'),
          );
        return ListView.builder(
          itemCount: state.currencies!.length + 1,
          itemBuilder: (context, index) {
            if(index == state.currencies!.length)
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                child: OutlinedButton.icon(
                  label: Text('Add new currency'),
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    final dynamic result = await Navigator.of(context).push(MaterialPageRoute(
                     builder: (context) => CurrencyScreen(),
                    ));
                    
                    if(result != null && result is Currency) {
                      final Currency c = result;
                      BlocProvider.of<CurrenciesAndTradesCubit>(context).updateCurrency(newCurrency: c);
                    }
                  },
                ),
              );
            return _CurrencyTile(currency: state.currencies![index]);
          },
        );
      },
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  final Currency currency;

  const _CurrencyTile({ required this.currency, Key? key }) : super(key: key);

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
      ),
    );
  }
}
