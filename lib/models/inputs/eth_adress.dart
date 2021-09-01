import 'package:formz/formz.dart';

// ignore: constant_identifier_names
const PREFIX = "0x";
// ignore: constant_identifier_names
const ALPHABET = "0123456789abcdefABCDEF";

class EthAddressInput extends FormzInput<String, String> {
  static const String labelText = "Address";
  static const String hintText = "0x13...37";

  const EthAddressInput.pure() : super.pure("");
  const EthAddressInput.dirty({String value = ""}) : super.dirty(value);

  @override
  String? validator(String value) {
    if(value.length < 40) {
      return "Isn't that kinda short?";
    }
    if(value.length > 64) {
      return "Isn't that kinda long?";
    }
    if(!value.startsWith("0x")) {
      return "That's not an address!";
    }
    for(int i = 2;i < value.length; ++i) {
      if(!ALPHABET.contains(value[i])) {
        return "Addresses can only contain hex chars!";
      }
    }
    return null;
  }
}
