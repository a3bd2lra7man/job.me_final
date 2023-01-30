import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/known_exception.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/user/_user_core/models/user.dart';
import 'package:job_me/user/sign_up/constants/signup_urls.dart';
import 'package:job_me/user/sign_up/models/signup_credentials.dart';

class SignUpSubmitter {
  final API _networkAdapter = API();
  bool isLoading = false;

  SignUpSubmitter();

  Future<User> signup(SignupCredentials credentials) async {
    isLoading = true;
    var url = SignupUrls.signUp();
    var apiRequest = APIRequest(url);
    apiRequest.addParameters(credentials.toJson());
    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on ServerSentException catch (e) {
      isLoading = false;
      var message = _getServerMessage(e);
      throw KnownException(message);
    } on APIException {
      isLoading = false;
      rethrow;
    }
  }

  Future<User> _processResponse(APIResponse apiResponse) async {
    if (apiResponse.data['Result'] == null ||
        apiResponse.data['Result']['Result'] == null ||
        apiResponse.data['Result']['Result']['user'] == null) {
      throw UnknownException();
    }
    var map = apiResponse.data['Result']['Result']['user'];
    map['token'] = apiResponse.data['Result']['Result']['token'];
    return User.fromJson(map);
  }

  String _getServerMessage(ServerSentException e) {
    if (e.errorResponse.runtimeType == String) return e.errorResponse;
    var serverMessage = '';
    if (e.errorResponse['password_confirmation'] != null) serverMessage = e.errorResponse['password_confirmation'][0];
    if (e.errorResponse['password'] != null) serverMessage = e.errorResponse['password'][0];
    if (e.errorResponse['email'] != null) serverMessage = e.errorResponse['email'][0];
    if (e.errorResponse['username'] != null) serverMessage = e.errorResponse['username'][0];
    if (e.errorResponse['fullname'] != null) serverMessage = e.errorResponse['fullname'][0];
    return serverMessage;
  }
}
