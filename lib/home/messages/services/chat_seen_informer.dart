import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/home/messages/constants/messages_urls.dart';

class ChatSeenInformer {
  final API _networkAdapter = API();
  bool isLoading = false;

  ChatSeenInformer();

  Future<bool> makeMessagesAsSeen(int senderId) async {
    isLoading = true;
    var url = ChatsUrls.makeChatSeenUrl();
    var apiRequest = APIRequest(url);
    apiRequest.addParameter("id", senderId);
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
