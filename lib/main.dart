import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yakuswap/cubits/currencies_and_trades/cubit.dart';
import 'package:yakuswap/cubits/eth/cubit.dart';
import 'package:yakuswap/repositories/allinone.dart';
import 'package:yakuswap/repositories/eth.dart';
import 'package:yakuswap/screens/currencies.dart';
import 'package:yakuswap/screens/eth_trades.dart';
import 'package:yakuswap/screens/trades.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AllInOneRepository allInOneRepo = AllInOneRepository();
    final EthRepository ethRepo = EthRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CurrenciesAndTradesCubit(repository: allInOneRepo)..initialize(),
        ),
        BlocProvider(
          create: (context) => EthCubit(allInOneRepository: allInOneRepo, ethRepository: ethRepo)..initialize(),
        ),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => allInOneRepo,
          ),
          RepositoryProvider(
            create: (context) => ethRepo,
          ),
        ],
        child: MaterialApp(
          title: 'yakuSwap',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.amber,
          ),
          home: const _TabController(),
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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('yakuSwap'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Currencies'),
              Tab(text: 'Fork Trades'),
              Tab(text: 'XCH - ETH'),
            ],
          ),
          actions: [
            Builder(builder: (context) => IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                 BlocProvider.of<CurrenciesAndTradesCubit>(context).refresh();
                 BlocProvider.of<EthCubit>(context).refresh();
              },
            )),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 24.0,
          ),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: const TabBarView(
                children: [
                  CurrenciesScreen(),
                  TradesScreen(),
                  EthTrades(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
