import 'package:job_me/_shared/api/constants/base_url.dart';

class CertificatesAndTrainingsUrls {

  static String addCertificateUrls() {
    return '${BaseUrls.baseUrl()}/certificates';
  }

  static String updateCertificateUrls(int id) {
    return '${BaseUrls.baseUrl()}/certificates/$id';
  }

  static String deleteCertificateUrls(int id) {
    return '${BaseUrls.baseUrl()}/certificates/$id';
  }

}
