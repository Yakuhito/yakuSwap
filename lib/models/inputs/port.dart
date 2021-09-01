import 'package:formz/formz.dart';

// ignore: constant_identifier_names
const ALPHABET = "0123456789";

class PortInput extends FormzInput<String, String> {
  static const String labelText = "Full Wallet Port";
  static const String hintText = "8555";

  const PortInput.pure() : super.pure("");
  const PortInput.dirty({String value = ""}) : super.dirty(value);

  @override
  String? validator(String value) {
    if(value.length < 2) {
      return "Uh...";
    }
    if(value.length > 5) {
      return "Hm...";
    }
    for(int i = 0;i < value.length; ++i) {
      if(!ALPHABET.contains(value[i])) {
        return "That's not a number!";
      }
    }
    return null;
  }
}
