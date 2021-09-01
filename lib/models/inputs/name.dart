import 'package:formz/formz.dart';

// ignore: constant_identifier_names
const ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

class NameInput extends FormzInput<String, String> {
  static const String labelText = "Name";
  static const String hintText = "Chia";

  const NameInput.pure() : super.pure("");
  const NameInput.dirty({String value = ""}) : super.dirty(value);

  @override
  String? validator(String value) {
    if(value.length < 3) {
      return "Name is too short";
    }
    if(value.length > 16) {
      return "Name is too long";
    }
    for(int i = 0;i < value.length; ++i) {
      if(!ALPHABET.contains(value[i])) {
        return "Contains forbidden chars :(";
    }
      }
    return null;
  }
}
