import 'package:get/get.dart';

class LanguageController extends GetxController {
  final selectedLanguage = 'English'.obs;

  void setLanguage(String language) {
    selectedLanguage.value = language;
  }
}
