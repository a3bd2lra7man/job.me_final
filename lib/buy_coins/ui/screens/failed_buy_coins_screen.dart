import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/home/home/ui/screens/home_page.dart';

class FailedBuyCoinsScreen extends StatelessWidget {
  const FailedBuyCoinsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/failed.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(
              context.translate('not_success_to_buy'),
              style: AppTextStyles.headerSmall.copyWith(color: AppColors.grey),
            ),
            const SizedBox(height: 40),
            PrimaryButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              title: context.translate('back_to_credit'),
              color: AppColors.primary,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              onPressed: () {
                Get.offAll(HomePage.init());
              },
              title: context.translate('home'),
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
