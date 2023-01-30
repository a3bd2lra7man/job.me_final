import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/home/offers/models/company_offer.dart';
import 'package:job_me/home/offers/ui/screens/company_offer_details_page.dart';

class CompanyOfferCard extends StatelessWidget {
  final CompanyOffer offer;

  const CompanyOfferCard({Key? key, required this.offer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(()=>CompanyOfferDetailsScreen.init(offer));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: SizedBox(
          height: 88,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      offer.title,
                      style: AppTextStyles.bodyMedium.copyWith(height: 1),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),

                  // Expanded(
                  //   child: Text(
                  //     employeeOffer.description,
                  //     style: AppTextStyles.bodyMedium.copyWith(height: 1),
                  //     overflow: TextOverflow.ellipsis,
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          context.translate('appliers_count'),
                          style: AppTextStyles.bodyMedium.copyWith(height: 1),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          offer.numberOfOffers.toString(),
                          style: AppTextStyles.bodyMedium.copyWith(height: 1),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
