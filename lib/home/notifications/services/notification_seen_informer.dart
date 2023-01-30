import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/home/notifications/constants/notifications_urls.dart';

class NotificationSeenInformer {
  final API _networkAdapter = API();
  bool isLoading = false;

  NotificationSeenInformer();

  Future<bool> makeNotificationsAsSeen() async {
    isLoading = true;
    var url = NotificationsUrls.makeNotificationsSeenUrl();
    var apiRequest = APIRequest(url);
    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on APIException {
      isLoading = false;
      rethrow;
    }
  }

  Future<bool> _processResponse(APIResponse apiResponse) async {
    if (apiResponse.statusCode != 200) {
      throw UnknownException();
    }
    return true;
  }
}
