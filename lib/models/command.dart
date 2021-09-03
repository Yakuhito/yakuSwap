import 'package:equatable/equatable.dart';

enum CommandType {waitForSwap, createSwap, completeSwap, cancelSwap}

class Command extends Equatable {
  final CommandType type;
  final Map<String, dynamic> args;

  const Command({
    required this.type,
    required this.args,
  });

  static CommandType _commandTypeFromString(String cmd) {
    switch(cmd) {
      case "WAIT_FOR_SWAP":
        return CommandType.waitForSwap;
      case "CREATE_SWAP":
        return CommandType.createSwap;
      case "COMPLETE_SWAP":
        return CommandType.completeSwap;
      case "CANCEL_SWAP":
      default:
        return CommandType.cancelSwap;
    }
  }

  static Command fromJSON(Map<String, dynamic> data) {
    return Command(type: _commandTypeFromString(data["code"]), args: Map<String, dynamic>.from(data["args"]));
  }

  @override
  List<Object?> get props => [type, ...args.keys, ...args.values];
}