import 'package:formz/formz.dart';

// ignore: constant_identifier_names
const ALPHABET = "0123456789";

class UnitsPerCoinInput extends FormzInput<String, String> {
  static const String labelText = "Units Per Coin";
  static const String hintText = "1000000000000";

  const UnitsPerCoinInput.pure() : super.pure("");
  const UnitsPerCoinInput.dirty({String value = ""}) : super.dirty(value);

  @override
  String? validator(String value) {
    if(value.length < 2) {
      return "Uh...";
    }
    if(value.length > 24) {
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
