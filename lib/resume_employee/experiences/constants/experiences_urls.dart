import 'package:job_me/_shared/api/constants/base_url.dart';

class ExperienceUrls {

  static String addExperienceUrls() {
    return '${BaseUrls.baseUrl()}/experiences';
  }

  static String updateExperienceUrls(int id) {
    return '${BaseUrls.baseUrl()}/experiences/$id';
  }

  static String deleteExperienceUrls(int id) {
    return '${BaseUrls.baseUrl()}/experiences/$id';
  }


}
