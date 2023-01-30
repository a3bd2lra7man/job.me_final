import 'package:job_me/_shared/api/constants/base_url.dart';

class AccountsUrl {
  static String deleteAccountUrl(){
    return "${BaseUrls.baseUrl()}/removeAccount";
  }

  static String balanceUrl(){
    return "${BaseUrls.baseUrl()}/plans";
  }
}
