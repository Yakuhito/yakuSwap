import 'package:formz/formz.dart';

// ignore: constant_identifier_names
const ALPHABET = "0123456789";

class TransactionAmountInput extends FormzInput<String, String> {
  static const String labelText = "Total Amount";
  static const String hintText = "100";

  const TransactionAmountInput.pure() : super.pure("");
  const TransactionAmountInput.dirty({String value = ""}) : super.dirty(value);

  @override
  String? validator(String value) {
    if(value.contains(".")) {
      return "Please use mojo / smallest unit to specify the amount!";
    }
    if(value.isEmpty) {
      return "Uh...";
    }
    if(value.length > 32) {
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
