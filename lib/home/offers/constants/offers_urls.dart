import 'package:job_me/_shared/api/constants/base_url.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';

class OfferUrls {
  static String employeeOffersUrls(int currentPage) {
    return "${BaseUrls.baseUrl()}/myOffers?page=$currentPage";
  }

  static String companyOffersUrls(int currentPage) {
    return "${BaseUrls.baseUrl()}/myAdsJobs?page=$currentPage";
  }

  static String companyJobDetailsUrls(int jobId) {
    var userId =  UserRepository().getUser().id;
    return "${BaseUrls.baseUrl()}/adsJobs/$jobId?user_id=$userId";
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
