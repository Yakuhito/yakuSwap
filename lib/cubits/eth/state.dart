part of 'cubit.dart';

enum EthStatus {loading, loaded, load_error}

class EthState extends Equatable {
  final EthStatus status;
  final bool walletConnected;
  final String? address;
  final List<EthTrade>? trades;

  const EthState._({
    this.status = EthStatus.loading,
    this.walletConnected = false,
    this.address,
    this.trades
  });

  const EthState.initial() : this._();
  const EthState.loading() : this._();
  const EthState.error() : this._(status:EthStatus.load_error);
  const EthState.loaded(bool walletConnected, {String? address, List<EthTrade>? trades}) : this._(
    status: EthStatus.loaded,
    walletConnected: walletConnected,
    address: address,
    trades: trades
  );

  @override
  List<Object?> get props => [status, walletConnected, address, trades];
}