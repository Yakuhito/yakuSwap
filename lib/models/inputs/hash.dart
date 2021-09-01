import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:formz/formz.dart';

// ignore: constant_identifier_names
const ALPHABET = "0123456789abcdef";

class HashInput extends FormzInput<String, String> {
  static const String labelText = "Secret Hash";
  static const String hintText = "f00dbabe...";

  const HashInput.pure() : super.pure("");
  const HashInput.dirty({String value = ""}) : super.dirty(value);
  HashInput.forSecret({required String secret}) : super.dirty(sha256.convert(utf8.encode(secret)).toString());

  @override
  String? validator(String value) {
    if(value.length != 64) {
      return "A hash is 64 chars long...";
    }
   for(int i = 0;i < value.length; ++i) {
     if(!ALPHABET.contains(value[i])) {
        return "Contains forbidden chars :(";
   }
      }
    return null;
  }
}
