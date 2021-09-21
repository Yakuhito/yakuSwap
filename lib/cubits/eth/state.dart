part of 'cubit.dart';

enum EthStatus {loading, loaded, loadError}

class EthState extends Equatable {
  final EthStatus status;
  final bool walletConnected;
  final String? address;
  final List<EthTrade>? trades;
  final List<EthNetwork>? networks;

  const EthState._({
    this.status = EthStatus.loading,
    this.walletConnected = false,
    this.address,
    this.trades,
    this.networks,
  });

  const EthState.initial() : this._();
  const EthState.loading() : this._();
  const EthState.error() : this._(status:EthStatus.loadError);
  const EthState.loaded(bool walletConnected, {String? address, List<EthTrade>? trades, List<EthNetwork>? networks}) : this._(
    status: EthStatus.loaded,
    walletConnected: walletConnected,
    address: address,
    trades: trades,
    networks: networks,
  );

  @override
  List<Object?> get props => [status, walletConnected, address, trades];
}