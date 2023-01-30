import 'package:job_me/_shared/api/constants/base_url.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';

class MainConstants {
  static String recentJobsUrls(int currentPage) {
    var userRepo = UserRepository();
    return "${BaseUrls.baseUrl()}/adsJobs?page=$currentPage&${userRepo.toQueryParameter()}";
  }

  static String specialJobsUrls(int currentPage) {
    var userRepo = UserRepository();
    return "${BaseUrls.baseUrl()}/adsJobs?page=$currentPage&special=true&${userRepo.toQueryParameter()}";
  }
}
