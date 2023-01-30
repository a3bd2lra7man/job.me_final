import 'package:job_me/_shared/api/constants/base_url.dart';

class ForgetPasswordUrls{
  static String checkEmail() {
    return '${BaseUrls.baseUrl()}/password/email';
  }

  static String checkCode() {
    return '${BaseUrls.baseUrl()}/password/code/check';
  }

  static String resetPassword() {
    return '${BaseUrls.baseUrl()}/password/reset';
  }
}