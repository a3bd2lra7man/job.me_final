import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/advertisement_core/proivders/my_ads_provider.dart';
import 'package:job_me/advertisement_special/ui/pages/add_ad_to_special_screen.dart';
import 'package:provider/provider.dart';

class PrepareToBeSpecialMyAdsCard extends StatefulWidget {
  final JobAdvertisement job;
  final double height;

  const PrepareToBeSpecialMyAdsCard({Key? key, required this.job, this.height = 88}) : super(key: key);

  @override
  State<PrepareToBeSpecialMyAdsCard> createState() => _PrepareToBeSpecialMyAdsCardState();
}

class _PrepareToBeSpecialMyAdsCardState extends State<PrepareToBeSpecialMyAdsCard> {
  @override
  Widget build(BuildContext context) {
    var myAdsProvider = context.watch<MyAdsProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: GestureDetector(
        onTap: () {
          Get.to(AddAdToSpecialScreen.init(jobAdvertisement: widget.job));
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: SizedBox(
            height: 64,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Text(
                      widget.job.title,
                      style: AppTextStyles.bodyMedium.copyWith(height: 1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Visibility(
                    visible: widget.job.isSpecial,
                    child: const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
