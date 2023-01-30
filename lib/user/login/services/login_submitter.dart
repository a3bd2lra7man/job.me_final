import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/user/login/models/social_login.dart';
import 'package:job_me/user/_user_core/models/user.dart';
import 'package:job_me/user/login/constants/login_urls.dart';
import 'package:job_me/user/login/models/login_credentials.dart';

class LoginSubmitter {
  final API _networkAdapter = API();
  bool isLoading = false;

  LoginSubmitter();

  Future<User> login(LoginCredentials credentials) async {
    isLoading = true;
    var url = LoginUrls.logIn();
    var apiRequest = APIRequest(url);
    apiRequest.addParameters(credentials.toJson());
    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on APIException {
      isLoading = false;
      rethrow;
    }
  }

  Future<User> socialLogin(SocialLoginModel credentials) async {
    isLoading = true;
    var url = LoginUrls.socialLogin();
    var apiRequest = APIRequest(url);
    apiRequest.addParameters(credentials.toJson());
    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on APIException {
      isLoading = false;
      rethrow;
    }
  }

  Future<User> _processResponse(APIResponse apiResponse) async {
    if (apiResponse.data['Result'] == null ||
        apiResponse.data['Result']['user'] == null) {
      throw UnknownException();
    }
    var map = apiResponse.data['Result']['user'];
    map['token'] = apiResponse.data['Result']['token'];
    return User.fromJson(map);
  }
}
