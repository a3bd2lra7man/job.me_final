import 'package:job_me/_shared/api/constants/base_url.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';

class JobDetailsUrls {
  static String jobUrls(int id) {
    var userId = "";
    var userRepo = UserRepository();
    if (userRepo.isUserLoggedIn()) {
      userId = "?user_id=${userRepo.getUser().id}";
    }
    return "${BaseUrls.baseUrl()}/adsJobs/$id$userId";
  }

  static addToSaved() {
    return "${BaseUrls.baseUrl()}/adSaved";
  }

  static removedFromSaved() {
    return "${BaseUrls.baseUrl()}/adSaved";
  }

  static applyForJob() {
    return "${BaseUrls.baseUrl()}/ApplyAndCancelJob";
  }

  static cancelJob() {
    return "${BaseUrls.baseUrl()}/ApplyAndCancelJob";
  }

  static pickEmployee() {
    return "${BaseUrls.baseUrl()}/acceptAndRefuseOffer";
  }

  static companyJobs(int currentPage) {
    return "${BaseUrls.baseUrl()}/myAdsJobs?page=$currentPage";
  }
}
