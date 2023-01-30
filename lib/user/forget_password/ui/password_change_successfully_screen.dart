import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_main/ui/splash_screen.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';

class PasswordChangedSuccessfullyScreen extends StatelessWidget {
  const PasswordChangedSuccessfullyScreen({Key? key}) : super(key: key);

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
              context.translate('password_change_successfully'),
              style: AppTextStyles.headerSmall.copyWith(color: AppColors.grey),
            ),
            const SizedBox(height: 40),
            PrimaryButton(
              onPressed: () {
                Get.offAll(const SplashScreen());
              },
              title: context.translate('back_to_login'),
              color: AppColors.primary,
            )
          ],
        ),
      ),
    );
  }
}
