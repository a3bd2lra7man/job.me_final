import 'package:job_me/_shared/api/constants/base_url.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';

class SearchUrls {
  static String searchNormalJobUrl(int currentPage, String searchText) {
    var userRepo = UserRepository();
    return "${BaseUrls.baseUrl()}/adsJobs?page=$currentPage&special=true&querySearch=$searchText&${userRepo.toQueryParameter()}";
  }

  static String searchSpecialJobUrl(int currentPage, String searchText) {
    var userRepo = UserRepository();
    return "${BaseUrls.baseUrl()}/adsJobs?page=$currentPage&querySearch=$searchText&${userRepo.toQueryParameter()}";
  }
}
