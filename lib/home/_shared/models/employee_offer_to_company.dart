import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';

enum EmployeeOfferToCompanyStatus {
  refused,
  accepted,
  underProcess;

  static EmployeeOfferToCompanyStatus fromInt(int status) {
    if (status == 0) return EmployeeOfferToCompanyStatus.refused;
    if (status == 1) return EmployeeOfferToCompanyStatus.accepted;
    if (status == 2) return EmployeeOfferToCompanyStatus.underProcess;
    return EmployeeOfferToCompanyStatus.refused;
  }
}

class EmployeeOfferToCompany extends JobAdvertisement {
  late EmployeeOfferToCompanyStatus status;
  EmployeeOfferToCompany.fromJson(Map map) : super.fromJson(map){
    status = EmployeeOfferToCompanyStatus.fromInt(map['statusOffer']);
  }
}
