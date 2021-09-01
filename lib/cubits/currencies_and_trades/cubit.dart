import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:yakuswap/models/currency.dart';
import 'package:yakuswap/models/full_node_connection.dart';
import 'package:yakuswap/models/trade.dart';
import 'package:yakuswap/repositories/allinone.dart';

part 'state.dart';

class CurrenciesAndTradesCubit extends Cubit<CurrenciesAndTradesState> {
  final AllInOneRepository repository;

  CurrenciesAndTradesCubit({required this.repository}) : super(const CurrenciesAndTradesState.initial());

  Future<void> initialize() => refresh();

  Future<void> refresh() async {
    emit(const CurrenciesAndTradesState.loading());
    try {
      final List<dynamic> results = await Future.wait([
        repository.getCurrencies(),
        repository.getTrades(),
      ]);
      
      final List<Currency> currencies = results[0];
      final List<Trade> trades = results[1];

      emit(CurrenciesAndTradesState.loaded(currencies, trades));

      final List<FullNodeConnection> connections = await repository.getConnections();
      emit(CurrenciesAndTradesState.loaded(currencies, trades, connections: connections));
    } catch(_) {
      emit(const CurrenciesAndTradesState.error());
    }
  }

  Future<void> updateCurrency({required Currency newCurrency}) async {
    emit(const CurrenciesAndTradesState.loading());
    await repository.putCurrency(currency: newCurrency);
    refresh();
  }

  Future<void> deleteCurrency({required String addressPrefix}) async {
    emit(const CurrenciesAndTradesState.loading());
    await repository.deleteCurrency(addressPrefix: addressPrefix);
    refresh();
  }

  Future<void> updateTrade({required Trade newTrade}) async {
    emit(const CurrenciesAndTradesState.loading());
    await repository.putTrade(trade: newTrade);
    refresh();
  }

  Future<void> deleteTrade({required String id}) async {
    emit(const CurrenciesAndTradesState.loading());
    await repository.deleteTrade(id: id);
    refresh();
  }
}