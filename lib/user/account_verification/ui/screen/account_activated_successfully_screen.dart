import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/home/home/ui/screens/home_page.dart';

class AccountActivatedSuccessfullyScreen extends StatelessWidget {
  const AccountActivatedSuccessfullyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/success.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(
              context.translate('account_activated_successfully'),
              style: AppTextStyles.headerSmall.copyWith(color: AppColors.grey),
            ),
            const SizedBox(height: 40),
            PrimaryButton(
              onPressed: () {
                Get.offAll(HomePage.init());
              },
              title: context.translate('home'),
              color: AppColors.primary,
            )
          ],
        ),
      ),
    );
  }
}
