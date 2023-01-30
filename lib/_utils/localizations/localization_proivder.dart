import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

late LocalizationProvider _provider;

class LocalizationProvider extends ChangeNotifier {
  LocalizationProvider._(this.locale);

  factory LocalizationProvider() {
    return _provider;
  }

  static const String _key = 'locale';
  String locale;

  static Future init() async {
    var shared = await SharedPreferences.getInstance();
    var locale = shared.getString(_key) ?? 'en';
    _provider = LocalizationProvider._(locale);
  }

  Future changeLanguageTo(String languageCode) async {
    locale = languageCode;
    notifyListeners();
    await Get.updateLocale(Locale(languageCode));
    var shared = await SharedPreferences.getInstance();
    await shared.setString(_key, languageCode);
  }

  bool isEn() {
    var isEn = locale == 'en';
    return isEn;
  }

  isLanguageSelected() async {
    var shared = await SharedPreferences.getInstance();
    return shared.getString(_key) != null;
  }
}
