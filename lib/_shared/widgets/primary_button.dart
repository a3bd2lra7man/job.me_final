import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Color? color;
  final Color? titleColor;
  final Color? borderColor;

  const PrimaryButton(
      {Key? key, required this.onPressed, required this.title, this.color, this.borderColor, this.titleColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width * .8,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          foregroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: borderColor == null
                ? BorderSide.none
                : BorderSide(
                    color: borderColor!,
                  ),
          ),
        ),
        child: Text(
          title,
          style: AppTextStyles.primaryButton.copyWith(color: titleColor),
        ),
      ),
    );
  }
}
