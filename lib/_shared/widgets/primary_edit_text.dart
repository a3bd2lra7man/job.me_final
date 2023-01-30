import 'package:flutter/material.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';

class PrimaryEditText extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType inputType;
  final String? Function(String?)? validator;

  const PrimaryEditText({
    Key? key,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.inputType = TextInputType.text,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: inputType,
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: AppTextStyles.hint.copyWith(color: AppColors.darkGrey),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.grey, width: 1)),
        border: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.grey, width: 1)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.grey, width: 1)),
      ),
      obscureText: obscureText,
    );
  }
}
