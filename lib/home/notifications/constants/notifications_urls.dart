import 'package:job_me/_shared/api/constants/base_url.dart';

class NotificationsUrls {
  static String fetchNotificationUrl(){
    return "${BaseUrls.baseUrl()}/notifications";
  }

  static String makeNotificationsSeenUrl(){
    return "${BaseUrls.baseUrl()}/notificationSeen";
  }
}
