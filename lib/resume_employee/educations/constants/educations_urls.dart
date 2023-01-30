import 'package:job_me/_shared/api/constants/base_url.dart';

class EducationsUrls {

  static String addEducationsUrl() {
    return '${BaseUrls.baseUrl()}/educations';
  }

  static String updateEducationsUrl(int id) {
    return '${BaseUrls.baseUrl()}/educations/$id';
  }

  static String deleteEducationsUrl(int id) {
    return '${BaseUrls.baseUrl()}/educations/$id';
  }

}
