import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';
import 'package:job_me/user/login/ui/screens/company_login_screen.dart';
import 'package:job_me/user/login/ui/screens/employee_login_screen.dart';

bool isUserNotLoggedIn(BuildContext context) {
  var isUserLoggedIn = UserRepository().isUserLoggedIn();
  if (isUserLoggedIn) return false;
  Get.bottomSheet(Container(
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 40,),
        Text(context.translate('need_to_login_message'),style: AppTextStyles.title,),
        const SizedBox(height: 20,),
        Text(context.translate('go_to_login'),style: AppTextStyles.headerBig,),
        const SizedBox(height: 40,),
        Row(
          children: [
            const Expanded(child: SizedBox()),
            Expanded(
              child: PrimaryButton(
                onPressed: () {
                  if (UserRepository().isEmployee()) {
                    Get.to(EmployeeLoginScreen.init());
                  } else {
                    Get.to(CompanyLoginScreen.init());
                  }
                },
                title: context.translate('yes'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PrimaryButton(
                color: AppColors.white,
                titleColor: AppColors.primary,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                title: context.translate('no'),
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
        const SizedBox(height: 80,),

      ],
    ),
  ));
  return true;
}
