import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/home/notifications/models/notification.dart' as models;
import 'package:job_me/home/notifications/services/notification_seen_informer.dart';
import 'package:job_me/home/notifications/services/notifications_fetcher.dart';

class NotificationsProvider extends ChangeNotifier {
  BuildContext context;

  NotificationsProvider(this.context);

  List<models.Notification> _notifications = [];

  List<models.Notification> get notifications => _notifications;

  List<models.Notification> get unSeenNotifications => _notifications.where((element) => !element.isSeen).toList();
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
      await _notificationsSeenInformer.makeNotificationsAsSeen();
      await fetchNotifications(notify: false);
      notifyListeners();
    } catch (_) {}
  }
}
