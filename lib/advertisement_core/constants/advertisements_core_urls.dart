import 'package:job_me/_shared/api/constants/base_url.dart';

class AdvertisementCoreUrls{


  static deleteAnAdJobUrl(int jobId) {
    return "${BaseUrls.baseUrl()}/adsJobs/$jobId";
  }

  static myAds(int currentPage){
    return "${BaseUrls.baseUrl()}/myAdsJobs?page=$currentPage";
  }



}