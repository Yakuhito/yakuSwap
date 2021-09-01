import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yakuswap/models/eth_trade.dart';
import 'package:yakuswap/repositories/allinone.dart';
import 'package:yakuswap/repositories/eth.dart';

part 'state.dart';

class EthCubit extends Cubit<EthState> {
  final AllInOneRepository allInOneRepository;
  final EthRepository ethRepository;

  EthCubit({required this.allInOneRepository, required this.ethRepository}) : super(const EthState.initial());

  Future<void> initialize() => refresh();

  Future<void> refresh({bool connectWallet = false}) async {
    emit(const EthState.loading());
    try {
      if(connectWallet) {
        await ethRepository.connectWallet();
      }

      String? address = ethRepository.getAddress();
      if(address == null) {
        emit(const EthState.loaded(false));
      } else {
        emit(EthState.loaded(true, address: address));
        ethRepository.registerListener();
        allInOneRepository.putAddress(address: address);

        final List<EthTrade> trades = await allInOneRepository.getEthTrades();
        emit(EthState.loaded(true, address: address, trades: trades));
      }
    } catch(_) {
      emit(const EthState.error());
    }
  }

  Future<void> updateTrade({required EthTrade trade}) async {
    emit(const EthState.loading());
    await allInOneRepository.putEthTrade(trade: trade);
    refresh();
  }

  Future<void> deleteTrade({required String id}) async {
    emit(const EthState.loading());
    await allInOneRepository.deleteEthTrade(id: id);
    refresh();
  }
}