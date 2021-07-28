part of 'cubit.dart';

enum CurrenciesAndTradesStatus {loading, loaded, load_error}

class CurrenciesAndTradesState extends Equatable {
  final CurrenciesAndTradesStatus status;
  final List<Currency>? currencies;
  final List<Trade>? trades;

  const CurrenciesAndTradesState._({
    this.status = CurrenciesAndTradesStatus.loading,
    this.currencies,
    this.trades,
  });

  const CurrenciesAndTradesState.initial() : this._();
  const CurrenciesAndTradesState.loading() : this._();
  const CurrenciesAndTradesState.error() : this._(status: CurrenciesAndTradesStatus.load_error);
  const CurrenciesAndTradesState.loaded(List<Currency> currencies, List<Trade> trades) : this._(
    status: CurrenciesAndTradesStatus.loaded,
    currencies: currencies,
    trades: trades,
  );

  @override
  List<Object?> get props => [status, currencies, trades];
}