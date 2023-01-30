import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/home/job_details/ui/screens/job_details_screen.dart';
import 'package:job_me/home/notifications/models/notification.dart';
import 'package:job_me/home/notifications/ui/screens/comapny_job_with_offer_details_sccreen.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';

class NotificationCard extends StatelessWidget {
  final Notification notification;

  const NotificationCard({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var userRepo = UserRepository();
        if (userRepo.isEmployee()) {
          Get.to(JobDetailsScreen.init(jobId: notification.jobId));
        } else {
          Get.to(CompanyJobWithOfferDetailsScreen.init(notification.jobId));
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
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    notification.jobName,
                    style: AppTextStyles.headerMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Divider(
                  color: AppColors.grey,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    notification.subTitle,
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
                const SizedBox(height: 16)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
