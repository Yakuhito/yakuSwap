import 'package:formz/formz.dart';

// ignore: constant_identifier_names
const String ALPHABET = "abcdefghijklmnopqrstuvwxyz";

class AddressPrefixInput extends FormzInput<String, String> {
  static const String labelText = "Address Prefix";
  static const String hintText = "xch";

  const AddressPrefixInput.pure() : super.pure("");
  const AddressPrefixInput.dirty({String value = ""}) : super.dirty(value);

  @override
  String? validator(String value) {
    for(int i = 0;i < value.length; ++i) {
      if(!ALPHABET.contains(value[i])) {
        return "Address prefix can only contain lowercase chars!";
    }
      }
    return null;
  }
}
