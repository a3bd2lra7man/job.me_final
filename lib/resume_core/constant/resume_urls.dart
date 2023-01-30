import 'package:job_me/_shared/api/constants/base_url.dart';

class ResumeUrls {
  static String fetchResume(int userId) {
    return '${BaseUrls.baseUrl()}/getCv?user_id=$userId';
  }
}
