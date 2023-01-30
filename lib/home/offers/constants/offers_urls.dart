import 'package:job_me/_shared/api/constants/base_url.dart';

class OfferUrls {
  static String employeeOffersUrls(int currentPage) {
    return "${BaseUrls.baseUrl()}/myOffers?page=$currentPage";
  }

  static String companyOffersUrls(int currentPage) {
    return "${BaseUrls.baseUrl()}/myAdsJobs?page=$currentPage";
  }

  static String companyJobDetailsUrls(int jobId) {
    return "${BaseUrls.baseUrl()}/adsJobs/$jobId";
  }

  static acceptOffer() {
    return "${BaseUrls.baseUrl()}/acceptAndRefuseOffer";
  }

  static cancelOffer() {
    return "${BaseUrls.baseUrl()}/acceptAndRefuseOffer";
  }

  static String fetchEmployeeResumeWithApplicationStatus(int employeeId,int jobToApply) {
    return '${BaseUrls.baseUrl()}/getCv?user_id=$employeeId&my_ads_id=$jobToApply';
  }
}
