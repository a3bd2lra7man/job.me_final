import 'dart:convert';

import 'package:flutter/material.dart' show ChangeNotifier, BuildContext;
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/home/_shared/providers/real_time_provider.dart';
import 'package:job_me/home/notifications/models/notification.dart' as models;
import 'package:job_me/home/notifications/services/notification_seen_informer.dart';
import 'package:job_me/home/notifications/services/notifications_fetcher.dart';
import 'package:provider/provider.dart';

class NotificationsProvider extends ChangeNotifier implements NotificationListener {
  BuildContext context;

  NotificationsProvider(this.context) {
    context.read<RealTimeProvider>().addNewNotificationListener(this);
  }

  int realTimeNotificationCount = 0;
  List<models.Notification> _notifications = [];

  List<models.Notification> get notifications => _notifications;

  List<models.Notification> get unSeenNotifications => _notifications.where((element) => !element.isSeen).toList();

  String get unSeenNotificationCount => (realTimeNotificationCount + unSeenNotifications.length).toString();

  bool isLoading = false;

  final _notificationsFetcher = NotificationsFetcher();
  final _notificationsSeenInformer = NotificationSeenInformer();

  Future fetchNotifications({bool notify = true}) async {
    if (notify) {
      isLoading = true;
      notifyListeners();
    }

    try {
      _notifications = await _notificationsFetcher.fetchNotifications();
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    if (notify) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future makeNotificationAsSeen() async {
    try {
      realTimeNotificationCount = 0;
      await _notificationsSeenInformer.makeNotificationsAsSeen();
      await fetchNotifications(notify: false);
      notifyListeners();
    } catch (_) {}
  }

  @override
  void onNewNotification(NotificationEvent notificationEvent) async {
    realTimeNotificationCount += 1;
    await fetchNotifications(notify: false);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    context.read<RealTimeProvider>().removeNotificationListener(this);
  }
}
