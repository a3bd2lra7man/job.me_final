import 'package:job_me/_shared/api/constants/base_url.dart';

class AdvertisementsSpecialUrls{


  static String boughtCoinsUrl(){
    return "${BaseUrls.baseUrl()}/plans";
  }

  static addToSpecial() {
    return "${BaseUrls.baseUrl()}/addThisAdsToSpecial";
  }

}