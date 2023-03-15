import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/home/account/providers/account_proivder.dart';
import 'package:provider/provider.dart';

class DeleteConfirmationDialog extends StatelessWidget {

  const DeleteConfirmationDialog({Key? key}) : super(key: key);

//language
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<AccountProvider>();
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
            context.translate('are_you_sure_to_delete_account'),
            textAlign: TextAlign.center,
            style: AppTextStyles.headerBig.copyWith(color: Colors.red),
          ),
          const SizedBox(height: 40),
          PrimaryButton(
            title: context.translate('yes'),
            onPressed: provider.deleteAccount,
            color: AppColors.primary,
            titleColor: AppColors.white,
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            title: context.translate('no'),
            onPressed: Get.back,
            color: AppColors.white,
            titleColor: AppColors.primary,
            borderColor: AppColors.primary,
          ),
          const SizedBox(height: 80)
        ],
      ),
    );
  }
}
