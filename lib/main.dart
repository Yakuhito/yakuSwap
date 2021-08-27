import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yakuswap/cubits/currencies_and_trades/cubit.dart';
import 'package:yakuswap/repositories/allinone.dart';
import 'package:yakuswap/screens/currencies.dart';
import 'package:yakuswap/screens/trades.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AllInOneRepository repo = AllInOneRepository();
    return BlocProvider<CurrenciesAndTradesCubit>(
      create: (context) => CurrenciesAndTradesCubit( repository: repo)..initialize(),
      child: RepositoryProvider<AllInOneRepository>(
        create: (context) => repo,
        child: MaterialApp(
          title: 'yakuSwap',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.amber,
          ),
          home: _TabController(),
        ),
      ),
    );
  }
}

class _TabController extends StatelessWidget {
  const _TabController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('yakuSwap'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Currencies'),
              Tab(text: 'Trades'),
            ],
          ),
          actions: [
            Builder(builder: (context) => IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => BlocProvider.of<CurrenciesAndTradesCubit>(context).refresh(),
            )),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 24.0,
          ),
          child: TabBarView(
            children: [
              CurrenciesScreen(),
              TradesScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
