import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';

class EmployeeOfferToCompanyCard extends StatelessWidget {
  final JobAdvertisement job;

  const EmployeeOfferToCompanyCard({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: job.userImage != null
                      ? CachedNetworkImage(
                          imageUrl: job.userImage!,
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
                        job.title,
                        style: AppTextStyles.bodyMedium.copyWith(height: 1),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        job.userName,
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
                          job.workTime.toString(),
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
