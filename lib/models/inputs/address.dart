import 'package:formz/formz.dart';

// ignore: constant_identifier_names
const ENC_ALPHABET = "qpzry9x8gf2tvdw0s3jn54khce6mua7l";
// ignore: constant_identifier_names
const PREFIX_ALPHABET = "abcdefghijklmnopqrstuvwxyz";

class AddressInput extends FormzInput<String, String> {
  static const String labelText = "Address";
  static const String hintText = "xch33 (...) 37a";

  const AddressInput.pure() : super.pure("");
  const AddressInput.dirty({String value = ""}) : super.dirty(value);

  @override
  String? validator(String value) {
    if(value.length < 60) {
      return "Isn't that kinda short?";
    }
    if(value.length > 78) {
      return "Isn't that kinda long?";
    }
    if(value.split("1").length != 2) {
      return "That's not an address!";
    }
    for(int i = 0;i < value.split("1")[0].length; ++i) {
      if(!PREFIX_ALPHABET.contains(value[i])) {
        return "Address prefix can only contain lowercase chars!";
      }
    }
    for(int i = value.split("1")[0].length + 1;i < value.length; ++i) {
      if(!ENC_ALPHABET.contains(value[i])) {
        return "Address contains weird chars";
    }
      }
    return null;
  }
}
