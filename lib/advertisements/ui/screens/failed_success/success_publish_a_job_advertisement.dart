import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/home/home/ui/screens/home_page.dart';

class SuccessfullyPublishedAJobAdvertisementScreen extends StatelessWidget {
  const SuccessfullyPublishedAJobAdvertisementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(.3),
              ),
              child: Image.asset(
                'assets/images/img_12.png',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.translate('success_adding_advertisement'),
              style: AppTextStyles.titleBold.copyWith(color: AppColors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              context.translate('good_luck'),
              style: AppTextStyles.titleBold.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              onPressed: () {
                Get.offAll(HomePage.init());
              },
              title: context.translate('home'),
              color: AppColors.primary,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              title: context.translate('advertise_again'),
              color: AppColors.white,
              borderColor: AppColors.primary,
              titleColor: AppColors.black,
            )
          ],
        ),
      ),
    );
  }
}
