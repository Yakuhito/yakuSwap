import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yakuswap/models/command.dart';
import 'package:yakuswap/models/eth_network.dart';
import 'package:yakuswap/models/eth_trade.dart';
import 'package:yakuswap/repositories/allinone.dart';
import 'package:yakuswap/repositories/eth.dart';

part 'state.dart';

class EthCubit extends Cubit<EthState> {
  final AllInOneRepository allInOneRepository;
  final EthRepository ethRepository;
  Map<String, Command> handlingCommands = {};
  Map<String, StreamSubscription> waitStreams = {};

  EthCubit({required this.allInOneRepository, required this.ethRepository}) : super(const EthState.initial());

  Future<void> initialize() => refresh();

  Future<void> refresh({bool connectWallet = false}) async {
    emit(const EthState.loading());
    handlingCommands = {};
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

        final List<EthTrade> trades = await allInOneRepository.getEthTrades();
        final List<EthNetwork> networks = await allInOneRepository.getEthNetworks();
        emit(EthState.loaded(true, address: address, trades: trades, networks: networks));
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

  void handleCommand({required String tradeId, required Command command, Function(String)? showMessage}) async {
    if(!waitStreams.containsKey(tradeId)) {
      waitStreams[tradeId] = ethRepository.waitForSwap(tradeId, command.args, showMessage).listen((event) {});
    }

    if(!handlingCommands.containsKey(tradeId) || (handlingCommands.containsKey(tradeId) && handlingCommands[tradeId] != command)) {
      switch(command.type) {
        case CommandType.createSwap:
          bool ok = await ethRepository.createSwap(tradeId, command.args, showMessage);
          if(ok) handlingCommands[tradeId] = command;
          break;
        case CommandType.waitForSwap:
          waitStreams[tradeId]?.cancel();
          waitStreams[tradeId] = ethRepository.waitForSwap(tradeId, command.args, showMessage).listen((event) {});
          handlingCommands[tradeId] = command;
          break;
        case CommandType.completeSwap:
          bool ok = await ethRepository.completeSwap(tradeId, command.args, showMessage);
          if(ok) handlingCommands[tradeId] = command;
          break;
        case CommandType.cancelSwap:
          bool ok = await ethRepository.cancelSwap(tradeId, command.args, showMessage);
          if(ok) handlingCommands[tradeId] = command;
          break;
        default:
          handlingCommands[tradeId] = command;
      }
    }
  }
}