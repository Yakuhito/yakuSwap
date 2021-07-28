import 'dart:io';

import 'package:formz/formz.dart';

class DirectoryInput extends FormzInput<String, String> {
  static const String labelText = "SSL Directory Path";
  static const String hintText = ".../mainnet/config/ssl";

  const DirectoryInput.pure() : super.pure("");
  const DirectoryInput.dirty({String value = ""}) : super.dirty(value);

  @override
  String? validator(String value) {
    if(Directory(value).existsSync())
      return null;
    return "That's not a directory";
  }
}
