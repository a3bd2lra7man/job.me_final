import 'package:flutter/material.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';

class LargeEditText extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;
  final int maxLines;
  final String hint;

  const LargeEditText({Key? key, required this.controller, required this.validator, this.maxLines = 10, required this.hint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: maxLines,
      maxLines: maxLines,
      validator: validator,
      cursorColor: AppColors.primary,
      controller: controller,
      decoration: InputDecoration(
        hintStyle: AppTextStyles.hint.copyWith(color: AppColors.grey),
        hintText: hint ,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.grey),
        ),
      ),
    );
  }
}
