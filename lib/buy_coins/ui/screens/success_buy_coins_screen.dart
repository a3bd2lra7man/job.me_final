import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/buy_coins/ui/screens/coins_screen.dart';
import 'package:job_me/home/home/ui/screens/home_page.dart';

class SuccessfullyBuyCoinsScreen extends StatelessWidget {
  final String coinsCount;

  const SuccessfullyBuyCoinsScreen({Key? key, required this.coinsCount}) : super(key: key);

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
              "${context.translate('add_is_done')} $coinsCount ${context.translate('to_your_credit')}",
              style: AppTextStyles.titleBold.copyWith(color: AppColors.grey),
            ),
            const SizedBox(height: 40),
            PrimaryButton(
              onPressed: () {
                Get.off( CoinsScreen.init());
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
