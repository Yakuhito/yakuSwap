import 'package:formz/formz.dart';

class HostInput extends FormzInput<String, String> {
  static const String labelText = "Host";
  static const String hintText = "127.0.0.1";

  const HostInput.pure() : super.pure("");
  const HostInput.dirty({String value = ""}) : super.dirty(value);

  @override
  String? validator(String value) {
    if(value.length < 5) {
      return "Uh...";
    }
    if(value.length > 32) {
      return "Hm...";
    }
    return null;
  }
}
