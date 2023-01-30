import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/home/job_details/ui/screens/job_details_screen.dart';
import 'package:job_me/home/offers/models/employee_offer.dart';

class EmployeeOfferCard extends StatelessWidget {
  final EmployeeOffer offer;

  const EmployeeOfferCard({Key? key, required this.offer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(JobDetailsScreen.init(jobId: offer.jobId));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: SizedBox(
          height: 88,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const SizedBox(
                  height: 64,
                  child: VerticalDivider(
                    width: 2,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.title,
                        style: AppTextStyles.bodyMedium.copyWith(height: 1),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          context.translate(offer.offerStatus.toReadableString()),
                          style: AppTextStyles.title.copyWith(height: 1),
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.circle,
                          color: _getColorFromStatus(offer.offerStatus),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorFromStatus(OfferStatus offerStatus) {
    switch (offerStatus) {
      case OfferStatus.refused:
        return Colors.red;
      case OfferStatus.accepted:
        return Colors.green;
      case OfferStatus.inProgress:
        return Colors.yellow;
      case OfferStatus.unknown:
        return Colors.white;
    }
  }
}
