import 'package:flutter/cupertino.dart';
import 'package:job_me/_utils/localizations/app_localization.dart';

extension BuildContextExtension on BuildContext {
  String translate(String key) => AppLocalizations.of(this).translate(key);
}
