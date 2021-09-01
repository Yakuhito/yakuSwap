import 'package:formz/formz.dart';

// ignore: constant_identifier_names
const ALPHABET = "0123456789";

class StepInput extends FormzInput<String, String> {
  static const String labelText = "Step";
  static const String hintText = "0";

  const StepInput.pure() : super.pure("");
  const StepInput.dirty({String value = ""}) : super.dirty(value);

  @override
  String? validator(String value) {
    if(value.length >= 2) {
      return "Uh...";
    }
    for(int i = 0;i < value.length; ++i) {
      if(!ALPHABET.contains(value[i])) {
        return "That's not a number!";
    }
      }
    return null;
  }
}
