import 'package:job_me/_shared/api/constants/base_url.dart';

class AdvertisementUrls{

  static String offersUrl(){
    return "${BaseUrls.baseUrl()}/plans";
  }

  static advertiseAJobUrl() {
    return "${BaseUrls.baseUrl()}/adsJobs";
  }

  static updateAnAdJobUrl(int jobId) {
    return "${BaseUrls.baseUrl()}/adsJobs/$jobId";
  }

  static deleteAnAdJobUrl(int jobId) {
    return "${BaseUrls.baseUrl()}/adsJobs/$jobId";
  }

  static myAds(int currentPage){
    return "${BaseUrls.baseUrl()}/myAdsJobs?page=$currentPage";
  }

  static addToSpecial() {
    return "${BaseUrls.baseUrl()}/addThisAdsToSpecial";
  }
}