import 'package:job_me/_shared/api/constants/base_url.dart';

class VerificationUrls {
  static String getVerifyEmailUrl(){
    return '${BaseUrls.baseUrl()}/verifyEmail';
  }
  static String getVerifyCodeUrl(){
    return '${BaseUrls.baseUrl()}/verifyBySMS';
  }
}
