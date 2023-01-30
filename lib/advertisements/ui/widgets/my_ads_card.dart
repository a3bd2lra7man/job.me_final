import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/advertisements/providers/my_ads_provider.dart';
import 'package:job_me/advertisements/ui/screens/update_job_advertisement_screen.dart';
import 'package:provider/provider.dart';

class MyAdsCard extends StatefulWidget {
  final JobAdvertisement job;
  final double height;

  const MyAdsCard({Key? key, required this.job, this.height = 88}) : super(key: key);

  @override
  State<MyAdsCard> createState() => _MyAdsCardState();
}

class _MyAdsCardState extends State<MyAdsCard> {
  @override
  Widget build(BuildContext context) {
    var myAdsProvider = context.watch<MyAdsProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
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
                GestureDetector(
                  onTap: () async {
                    Get.to(() => UpdateJobAdvertisementScreen.init(widget.job));
                  },
                  child: Icon(
                    Icons.edit,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                myAdsProvider.isTransactionLoading
                    ? const CircularProgressIndicator()
                    : GestureDetector(
                        onTap: () async {
                          myAdsProvider.deleteAnAd(widget.job);
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
