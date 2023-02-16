import 'package:job_me/_shared/api/constants/base_url.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';

class SearchUrls {
  static String searchNormalJobUrl(int currentPage, String searchText,int? categoryId,String? country) {
    var userRepo = UserRepository();
    var url =  "${BaseUrls.baseUrl()}/adsJobs?page=$currentPage&special=true&querySearch=$searchText&${userRepo.toQueryParameter()}";
    if(categoryId != null) url += "&category=$categoryId";
    if(country != null) url += "&country=$country";
    return url;
  }

  static String searchSpecialJobUrl(int currentPage, String searchText,int? categoryId,String? country) {
    var userRepo = UserRepository();
    var url = "${BaseUrls.baseUrl()}/adsJobs?page=$currentPage&querySearch=$searchText&${userRepo.toQueryParameter()}";
    if(categoryId != null) url += "&category=$categoryId";
    if(country != null) url += "&country=$country";
    return url;

  }

  static String categoriesUrl() {
    return "${BaseUrls.baseUrl()}/categories";
  }

  static String countriesUrl() {
    return "${BaseUrls.baseUrl()}/getAdsCountries";
  }
}
