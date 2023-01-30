import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/home/home/ui/screens/home_page.dart';

class FailedPublishedJobAdvertisementScreen extends StatelessWidget {
  const FailedPublishedJobAdvertisementScreen({Key? key}) : super(key: key);

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
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.redAccent.withOpacity(.3),
              ),
              child: Image.asset(
                'assets/images/img_13.png',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.translate('not_enough_credit'),
              style: AppTextStyles.title.copyWith(color: AppColors.darkGrey),
            ),
            Text(
              context.translate('in_special_ads'),
              style: AppTextStyles.title.copyWith(color: AppColors.darkGrey),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              onPressed: () {
                Get.offAll(HomePage.init());
              },
              title: context.translate('home'),
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
