import 'package:formz/formz.dart';

// ignore: constant_identifier_names
const ALPHABET = "0123456789";

class MinConfirmationHeightInput extends FormzInput<String, String> {
  static const String labelText = "Min Confirmation Height";
  static const String hintText = "32";

  const MinConfirmationHeightInput.pure() : super.pure("");
  const MinConfirmationHeightInput.dirty({String value = ""}) : super.dirty(value);

  @override
  String? validator(String value) {
    if(value.length < 2) {
      return "Uh...";
    }
    if(value.length > 6) {
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
