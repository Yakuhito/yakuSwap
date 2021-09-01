import 'dart:math';

import 'package:formz/formz.dart';

// ignore: constant_identifier_names
const ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-";

class SecretInput extends FormzInput<String, String> {
  static const String labelText = "Secret";
  static const String hintText = "SECRET-01kkK...";

  static String generateSecret() {
    String secret = "SECRET";
    
    var r = Random.secure();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    for(int i = 0; i < 4; ++i) {
      secret += "-" + List.generate(8, (index) => _chars[r.nextInt(_chars.length)]).join();
    }

    return secret;
  }

  const SecretInput.pure() : super.pure("");
  const SecretInput.dirty({String value = ""}) : super.dirty(value);

  @override
  String? validator(String value) {
    if(value.isEmpty) return null;
    if(!value.startsWith("SECRET-")) {
      return "Invalid secret!";
    }
    if(value.length < 32) {
      return "Secret is too short";
    }
    if(value.length > 100) {
      return "Secret is too long";
    }
    for(int i = 0;i < value.length; ++i) {
      if(!ALPHABET.contains(value[i])) {
        return "Contains forbidden chars :(";
      }
    }
    return null;
  }
}
