import 'package:job_me/_shared/api/constants/base_url.dart';

class SavedJobsUrls{
  static String savedJobsUrls(int currentPage){
    return "${BaseUrls.baseUrl()}/savedAds?page=1";
  }
}