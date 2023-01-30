import 'package:job_me/_shared/api/constants/base_url.dart';

class CompanyDepartmentsUrls {

  static String fetchCompanyDepartmentUrl() {
    return '${BaseUrls.baseUrl()}/subCompanyInfo';
  }

  static String addCompanyDepartmentUrl() {
    return '${BaseUrls.baseUrl()}/subCompanyInfo';
  }

  static String updateCompanyDepartmentUrls(int companyId) {
    return '${BaseUrls.baseUrl()}/subCompanyInfo/$companyId';
  }

  static String deleteCompanyDepartmentUrls(int companyId) {
    return '${BaseUrls.baseUrl()}/subCompanyInfo/$companyId';
  }

}
