import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/user/_user_core/models/user.dart';
import 'package:job_me/user/login/providers/login_provider.dart';
import 'package:provider/provider.dart';

class YouAreNotCompanyBottomSheet extends StatelessWidget {
  final User user;
  final Color blueColor = const Color.fromRGBO(0, 169, 192, 1);

  const YouAreNotCompanyBottomSheet({Key? key, required this.user}) : super(key: key);

//language
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<LoginProvider>();
    return Container(
      // height: sizeH300,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40),
          Text(
            context.translate('you_are_not_company'),
            textAlign: TextAlign.center,
            style: AppTextStyles.headerBig.copyWith(color: blueColor),
          ),
          const SizedBox(height: 40),
          PrimaryButton(
            title: context.translate('yes'),
            onPressed: () => provider.saveUserThenGoToHomePage(user),
            color: blueColor,
            titleColor: AppColors.white,
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            title: context.translate('no'),
            onPressed: Get.back,
            color: AppColors.white,
            titleColor: blueColor,
            borderColor: blueColor,
          ),
          const SizedBox(height: 80)
        ],
      ),
    );
  }
}
