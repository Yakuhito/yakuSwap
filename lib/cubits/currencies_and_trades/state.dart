part of 'cubit.dart';

enum CurrenciesAndTradesStatus {loading, loaded, loadError}

class CurrenciesAndTradesState extends Equatable {
  final CurrenciesAndTradesStatus status;
  final List<Currency>? currencies;
  final List<Trade>? trades;  
  final List<FullNodeConnection>? connections;

  const CurrenciesAndTradesState._({
    this.status = CurrenciesAndTradesStatus.loading,
    this.currencies,
    this.trades,
    this.connections,
  });

  const CurrenciesAndTradesState.initial() : this._();
  const CurrenciesAndTradesState.loading() : this._();
  const CurrenciesAndTradesState.error() : this._(status: CurrenciesAndTradesStatus.loadError);
  const CurrenciesAndTradesState.loaded(List<Currency> currencies, List<Trade> trades, {List<FullNodeConnection>? connections}) : this._(
    status: CurrenciesAndTradesStatus.loaded,
    currencies: currencies,
    trades: trades,
    connections: connections,
  );

  @override
  List<Object?> get props => [status, currencies, trades, connections];
}