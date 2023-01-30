import 'package:flutter/material.dart';

import 'colors.dart';

const String _fontFamily = 'Cairo';

class AppTextStyles {
  static TextStyle get headerHuge =>
      TextStyle(fontSize: 37, fontWeight: FontWeight.bold, fontFamily: _fontFamily, color: AppColors.white);

  static TextStyle get headerBig =>
      TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: _fontFamily, color: AppColors.primary);

  static TextStyle get headerMedium =>
      TextStyle(fontSize: 25, fontWeight: FontWeight.w100, fontFamily: _fontFamily, color: AppColors.white);

  static TextStyle get headerSemiBold => TextStyle(
      fontSize: 25, fontWeight: FontWeight.w700, fontFamily: _fontFamily, color: AppColors.lightGrey.withOpacity(.8));

  static TextStyle get headerSmall =>
      TextStyle(fontSize: 23, fontWeight: FontWeight.bold, fontFamily: _fontFamily, color: AppColors.black);

  static TextStyle get hint =>
      TextStyle(fontSize: 16, fontWeight: FontWeight.w100, fontFamily: _fontFamily, color: AppColors.grey);

  static TextStyle get hintBold =>
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: _fontFamily, color: AppColors.darkGrey);

  static TextStyle get bodyNormal =>
      TextStyle(fontSize: 18, fontWeight: FontWeight.w100, fontFamily: _fontFamily, color: AppColors.darkGrey);

  static TextStyle get bodyMedium =>
      TextStyle(fontSize: 18, fontWeight: FontWeight.w400, fontFamily: _fontFamily, color: AppColors.black);

  static TextStyle get titleBold =>
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: _fontFamily, color: AppColors.black);

  static TextStyle get title =>
      TextStyle(fontSize: 20, fontWeight: FontWeight.w100, fontFamily: _fontFamily, color: AppColors.black);

  static TextStyle get smallStyle =>
      TextStyle(fontSize: 12, fontWeight: FontWeight.w100, fontFamily: _fontFamily, color: AppColors.darkGrey);

  static TextStyle get primaryButton => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        fontFamily: _fontFamily,
        color: Colors.white,
      );
}
