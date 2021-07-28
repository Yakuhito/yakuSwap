import 'dart:math';

import 'package:formz/formz.dart';

const ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-";

class IdInput extends FormzInput<String, String> {
  static const String labelText = "ID";
  static const String hintText = "ID-SOMETHING-rAnD0m";

  static String generateId() {
    String secret = "YAKU";
    
    var r = Random.secure();
    const _chars = '0123456789ABCDEF';
    for(int i = 0; i < 2; ++i)
      secret += "-" + List.generate(8, (index) => _chars[r.nextInt(_chars.length)]).join();

    return secret;
  }

  const IdInput.pure() : super.pure("");
  const IdInput.dirty({String value = ""}) : super.dirty(value);

  @override
  String? validator(String value) {
    if(!value.startsWith("YAKU-"))
      return "Not a valid id";
    if(value.length < 22)
      return "Id is too short";
    if(value.length > 28)
      return "Id is too long";
    for(int i = 0;i < value.length; ++i)
      if(!ALPHABET.contains(value[i]))
        return "Contains forbidden chars :(";
    return null;
  }
}
