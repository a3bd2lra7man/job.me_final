import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/user/change_password/constants/change_password_urls.dart';

class ChangePasswordExecutor {
  final API _networkAdapter = API();
  bool isLoading = false;

  ChangePasswordExecutor();

  Future sendNewPassword(String oldPassword, String password, String passwordConfirmation) async {
    isLoading = true;
    var url = ChangePasswordUrls.changePassword();
    var apiRequest = APIRequest(url);
    apiRequest.addParameter("password", oldPassword);
    apiRequest.addParameter("new_password", password);
    apiRequest.addParameter("password_confirmation", passwordConfirmation);
    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      isLoading = false;
      return _processSuccessResponse(apiResponse);
    } on APIException {
      isLoading = false;
      rethrow;
    }
  }

  Future _processSuccessResponse(APIResponse apiResponse) async {
    if (apiResponse.data['Status'] != true) {
      throw UnknownException();
    }
  }
}
