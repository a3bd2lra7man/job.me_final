import 'dart:async';

import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/home/notifications/constants/notifications_urls.dart';
import 'package:job_me/home/notifications/models/notification.dart';

class NotificationsFetcher {
  final API _api;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  NotificationsFetcher() : _api = API();

  Future<List<Notification>> fetchNotifications() async {
    var url = NotificationsUrls.fetchNotificationUrl();
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);

    _isLoading = true;
    try {
      var apiResponse = await _api.get(apiRequest);
      _isLoading = false;
      return _processResponse(apiResponse);
    } on APIException {
      _isLoading = false;
      rethrow;
    }
  }

  Future<List<Notification>> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<Notification>>().future;
    if (apiResponse.data == null) throw UnknownException();
    if (apiResponse.data['Result'] == null) throw UnknownException();
    if (apiResponse.data['Result']['notifcations'] == null) throw UnknownException();

    var responseList = apiResponse.data['Result']['notifcations'] as List;

    var notifications = <Notification>[];
    try {
      for (var element in responseList) {
        notifications.add(Notification.fromJson(element));
      }
      return notifications;
    } catch (e) {
      throw UnknownException();
    }
  }

  bool get isLoading => _isLoading;
}
