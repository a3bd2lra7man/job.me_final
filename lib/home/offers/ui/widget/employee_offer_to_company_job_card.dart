import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/home/offers/providers/company_offers_details_provider.dart';
import 'package:job_me/home/offers/ui/screens/accept_employee_application_screen.dart';

class EmployeeOfferToCompanyJobCard extends StatelessWidget {
  final JobAdvertisement employeeOfferToCompany;
  final int jobToApply;
  final CompanyOffersDetailsProvider? provider;

  const EmployeeOfferToCompanyJobCard({Key? key, required this.employeeOfferToCompany, required this.jobToApply, required this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(AcceptEmployeeApplicationScreen.init(
            provider: provider, employeeAdId: employeeOfferToCompany.userId!, jobToApplyId: jobToApply));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: SizedBox(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: employeeOfferToCompany.userImage != null
                      ? CachedNetworkImage(
                          imageUrl: employeeOfferToCompany.userImage!,
                          height: 80,
                          width: 80,
                          placeholder: (_, __) =>  Image.asset(
                            'assets/images/unknown_person.png',
                            height: 80,
                            width: 80,
                          ),
                        )
                      : Image.asset(
                          'assets/images/img_2.png',
                          height: 80,
                          width: 80,
                        ),
                ),
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
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employeeOfferToCompany.title,
                        style: AppTextStyles.bodyMedium.copyWith(height: 1),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        employeeOfferToCompany.userName,
                        style: AppTextStyles.hint.copyWith(color: AppColors.darkGrey, height: 1),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          employeeOfferToCompany.workTime.toString(),
                          style: AppTextStyles.title.copyWith(height: 1),
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          context.translate('hours'),
                          style: AppTextStyles.title.copyWith(height: 1),
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
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
}
