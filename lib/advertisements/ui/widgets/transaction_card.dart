import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/loading_widget.dart';
import 'package:job_me/advertisements/models/bought_coins_plan.dart';
import 'package:job_me/advertisements/providers/ad_to_special_provider.dart';
import 'package:job_me/advertisements/providers/my_ads_provider.dart';
import 'package:job_me/advertisements/ui/screens/failed_success/success_publish_a_job_advertisement_to_special.dart';
import 'package:provider/provider.dart';

class TransactionCard extends StatefulWidget {
  final JobAdvertisement jobAdvertisement;
  final BoughtCoinsPlan transaction;

  const TransactionCard({
    Key? key,
    required this.transaction,
    required this.jobAdvertisement,
  }) : super(key: key);

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> with RouteAware {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<AdToSpecialProvider>();
    var myAdsProvider = context.watch<MyAdsProvider>();
    return GestureDetector(
      onTap: () async {
        setState(() {
          isLoading = true;
        });
        var isSuccess =
            await provider.addToSpecial(jobAdvertisement: widget.jobAdvertisement, transaction: widget.transaction);
        if (isSuccess != null && isSuccess == true) {
          Get.to(()=>const SuccessfullyPublishedAJobAdvertisementToSpecialScreen());
        } else {
          setState(() {
            isLoading = false;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Card(
          margin: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: ListTile(
              title: Text(
                widget.transaction.itemName,
                style: AppTextStyles.bodyMedium,
              ),
              trailing: isLoading
                  ? const LoadingWidget()
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              context.translate('quantity'),
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, height: 1.4),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.transaction.quantity.toString(),
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, height: 1.4),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
              leading: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.3),
                ),
                child: Image.asset(
                  "assets/images/img_6.png",
                  width: 64,
                  height: 64,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
