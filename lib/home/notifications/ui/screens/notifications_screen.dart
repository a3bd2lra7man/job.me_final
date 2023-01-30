import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/home/notifications/providers/notifications_provider.dart';
import 'package:job_me/home/notifications/ui/widgets/notification_card.dart';
import 'package:job_me/home/notifications/ui/widgets/notification_loader.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatelessWidget {
  static Widget init(NotificationsProvider provider) {
    provider.makeNotificationAsSeen();
    return ChangeNotifierProvider.value(value: provider, child: const NotificationsScreen._());
  }

  const NotificationsScreen._({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<NotificationsProvider>();
    return Scaffold(
      appBar: PrimaryAppBar(
        elevation: 0,
        title: context.translate('notifications'),
        titleColor: AppColors.black,
      ),
      body: Container(
        color: AppColors.primary.withOpacity(.04),
        child: provider.isLoading
            ? const NotificationsLoader()
            : provider.notifications.isEmpty
                ? Center(
                    child: Text(
                      context.translate('no_notifications'),
                      style: AppTextStyles.titleBold.copyWith(color: AppColors.darkGrey),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: provider.notifications
                        .map((notification) => NotificationCard(notification: notification))
                        .toList(),
                  ),
      ),
    );
  }
}
