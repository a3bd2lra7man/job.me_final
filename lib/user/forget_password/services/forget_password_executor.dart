import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/user/forget_password/constants/forget_password_urls.dart';

class ForgetPasswordExecutor {
  final API _networkAdapter = API();
  bool isLoading = false;

  ForgetPasswordExecutor();

  Future checkEmail(String email) async {
    isLoading = true;
    var url = ForgetPasswordUrls.checkEmail();
    var apiRequest = APIRequest(url);
    apiRequest.addParameter("email", email);
    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      isLoading = false;
      return _processSuccessResponse(apiResponse);
    } on APIException {
      isLoading = false;
      rethrow;
    }
  }

  Future checkCode(String code) async {
    isLoading = true;
    var url = ForgetPasswordUrls.checkCode();
    var apiRequest = APIRequest(url);
    apiRequest.addParameter("code", code);
    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      isLoading = false;
      return _processSuccessResponse(apiResponse);
    } on APIException {
      isLoading = false;
      rethrow;
    }
  }

  Future sendNewPassword(String code,String password, String passwordConfirmation) async {
    isLoading = true;
    var url = ForgetPasswordUrls.resetPassword();
    var apiRequest = APIRequest(url);
    apiRequest.addParameter("code", code);
    apiRequest.addParameter("password", password);
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
