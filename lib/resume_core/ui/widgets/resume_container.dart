import 'package:flutter/material.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';

class ResumeContainer extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String buttonText;
  final List<Widget> children;
  final IconData iconData;

  final VoidCallback? onButtonClicked;

  const ResumeContainer(
      {Key? key,
      required this.title,
      required this.children,
      required this.buttonText,
      this.onButtonClicked,
      required this.iconData,
      this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 8),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: AppColors.lightGrey.withOpacity(.35),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  topLeft: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleBold,
                  ),
                  const Spacer(),
                  if (subTitle != null)
                    Text(
                      subTitle!,
                      style: AppTextStyles.titleBold.copyWith(color: AppColors.primary),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Visibility(
              visible: onButtonClicked != null,
              child: GestureDetector(
                onTap: onButtonClicked,
                child: Row(
                  children: [
                    const SizedBox(width: 32),
                    Icon(
                      iconData,
                      color: AppColors.primary,
                      size: 32,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      buttonText,
                      style: AppTextStyles.hint.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
