import 'package:job_me/_shared/api/constants/base_url.dart';

class LoginUrls{
  static String logIn() {
    return '${BaseUrls.baseUrl()}/login';
  }

  static String socialLogin() {
    return '${BaseUrls.baseUrl()}/socialLogin';
  }
}