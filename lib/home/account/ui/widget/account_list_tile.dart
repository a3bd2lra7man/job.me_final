import 'package:flutter/material.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';

class AccountListTile extends StatelessWidget {
  final VoidCallback onTap;
  final Widget icon;
  final Widget? trailingIcon;
  final String title;
  final Color? titleColor;

  const AccountListTile({Key? key, required this.onTap, required this.icon, this.trailingIcon, required this.title, this.titleColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(4),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                icon,
                const SizedBox(width: 16),
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(color: titleColor),
                ),
                const Spacer(),
                trailingIcon ??
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.darkGrey,
                      size: 20,
                    ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
