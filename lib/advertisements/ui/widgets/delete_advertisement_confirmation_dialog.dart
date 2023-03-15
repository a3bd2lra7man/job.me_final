import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/advertisement_core/proivders/my_ads_provider.dart';
import 'package:provider/provider.dart';

class DeleteAdvertisementConfirmationDialog extends StatelessWidget {
  final JobAdvertisement jobAdvertisement;
  const DeleteAdvertisementConfirmationDialog({Key? key, required this.jobAdvertisement}) : super(key: key);

//language
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<MyAdsProvider>();
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
            context.translate('are_you_sure_to_delete_advertisement'),
            textAlign: TextAlign.center,
            style: AppTextStyles.headerBig.copyWith(color: Colors.red),
          ),
          const SizedBox(height: 40),
          PrimaryButton(
            title: context.translate('yes'),
            onPressed:()=> provider.deleteAnAd(jobAdvertisement),
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
