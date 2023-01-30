import 'package:job_me/_shared/api/constants/base_url.dart';

class ChangePasswordUrls{

  static String changePassword() {
    return '${BaseUrls.baseUrl()}/changePassword';
  }
}