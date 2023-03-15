import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/loading_widget.dart';
import 'package:job_me/advertisement_special/providers/ad_to_special_provider.dart';
import 'package:job_me/advertisement_core/models/bought_coins_plan.dart';
import 'package:job_me/advertisement_special/ui/pages/success_publish_a_job_advertisement_to_special.dart';
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
    return GestureDetector(
      onTap: () async {
        setState(() {
          isLoading = true;
        });
        var isSuccess =
            await provider.addToSpecial(jobAdvertisement: widget.jobAdvertisement, transaction: widget.transaction);
        if (isSuccess != null && isSuccess == true) {
          Get.to(() => const SuccessfullyPublishedAJobAdvertisementToSpecialScreen());
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
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
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.transaction.itemName,
                          style: AppTextStyles.bodyMedium,
                        ),
                        Row(
                          children: [
                            Text(
                              "${context.translate('quantity')} : ",
                              style: AppTextStyles.bodyMedium.copyWith(height: 1.4),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.transaction.quantity.toString(),
                              style: AppTextStyles.bodyMedium.copyWith(height: 1.4),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Center(
                  child: Text(
                    widget.transaction.description,
                    textAlign: TextAlign.start,
                    style: AppTextStyles.titleBold,
                  ),
                ),
                const SizedBox(height: 16),
                isLoading
                    ? const Center(child: LoadingWidget())
                    : Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            context.translate('advertise_to_special'),
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, height: 1.4),
                          ),
                        ),
                      ),
                const SizedBox(height: 16),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
