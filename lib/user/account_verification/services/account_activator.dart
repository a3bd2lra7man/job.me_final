import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/user/_user_core/models/user.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';
import 'package:job_me/user/account_verification/constants/verification_urls.dart';

class AccountActivator {
  final API _networkAdapter = API();
  bool isLoading = false;

  AccountActivator();

  Future verifyEmail(String email) async {
    isLoading = true;
    var url = VerificationUrls.getVerifyEmailUrl();
    var apiRequest = APIRequest(url);
    apiRequest.addParameters({'email': email});
    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      isLoading = false;
      return _processVerifyEmailResponse(apiResponse);
    } on APIException {
      isLoading = false;
      rethrow;
    }
  }

  Future<User> verifyCode(String phone) async {
    isLoading = true;
    var url = VerificationUrls.getVerifyCodeUrl();
    var apiRequest = APIRequest(url);
    apiRequest.addParameters({'phone_number': phone});
    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      isLoading = false;
      return await _processVerifyCodeResponse(apiResponse);
    } on APIException {
      isLoading = false;
      rethrow;
    }
  }

  Future _processVerifyEmailResponse(APIResponse apiResponse) async {
    if (apiResponse.data['Result'] == null || apiResponse.data['Status'] != true) {
      throw UnknownException();
    }
  }

  Future<User> _processVerifyCodeResponse(APIResponse apiResponse) async {
    if (apiResponse.data['Result'] == null || apiResponse.data['Status'] != true) {
      throw UnknownException();
    }
    var token = UserRepository().getUser().token;
    var userMap = apiResponse.data['Result'];
    userMap['token'] = token;
    return User.fromJson(userMap);
  }
}
