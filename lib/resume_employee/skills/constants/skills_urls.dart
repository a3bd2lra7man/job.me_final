import 'package:job_me/_shared/api/constants/base_url.dart';

class SkillsUrls {

  static String addSkillUrls() {
    return '${BaseUrls.baseUrl()}/skills';
  }

  static String updateSkillUrls(int id) {
    return '${BaseUrls.baseUrl()}/skills/$id';
  }

  static String deleteSkillUrls(int id) {
    return '${BaseUrls.baseUrl()}/skills/$id';
  }
}
