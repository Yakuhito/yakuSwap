import 'package:formz/formz.dart';

class PhotoURLInput extends FormzInput<String, String> {
  static const String labelText = "Photo URL";
  static const String hintText = "https://www(...)/logo.svg";

  const PhotoURLInput.pure() : super.pure("");
  const PhotoURLInput.dirty({String value = ""}) : super.dirty(value);

  @override
  String? validator(String value) {
    if(value.length < 8) {
      return "Photo URL is too short";
    }
    if(value.length > 512) {
      return "Photo URL is too long";
    }
    bool valid = Uri.tryParse(value)?.hasAbsolutePath ?? false;
    if(!valid) {
      return "That's not a valid URL!";
    }
    return null;
  }
}
