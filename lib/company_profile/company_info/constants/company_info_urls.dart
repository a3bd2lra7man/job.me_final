import 'package:job_me/_shared/api/constants/base_url.dart';

class CompanyInfoUrls {

  static String fetchCompanyInfoUrl() {
    return '${BaseUrls.baseUrl()}/companyInfo';
  }

  static String addCompanyInfoUrl() {
    return '${BaseUrls.baseUrl()}/companyInfo';
  }

  static String updateCompanyInfoUrls() {
    return '${BaseUrls.baseUrl()}/companyInfo';
  }

  static String deleteCompanyInfoUrls(int companyId) {
    return '${BaseUrls.baseUrl()}/companyInfo/$companyId';
  }

}
