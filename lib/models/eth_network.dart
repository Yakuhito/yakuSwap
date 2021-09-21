import 'package:equatable/equatable.dart';

class EthNetwork extends Equatable {
  final String name;
  final String contractAddress;
  final Map<String, String> tokenAddresses;

  const EthNetwork({
    required this.name,
    required this.contractAddress,
    required this.tokenAddresses
  });

  EthNetwork.fromJSON(Map<String, dynamic> data) :
    name = data['name'],
    contractAddress = data['address'],
    tokenAddresses = Map<String, String>.from(data['token_addresses']);

  Map<String, dynamic> toJSON() => {
    "name": name,
    "address": contractAddress,
    "token_addresses": tokenAddresses
  };

  @override
  List<Object?> get props => [name, contractAddress, tokenAddresses];
}