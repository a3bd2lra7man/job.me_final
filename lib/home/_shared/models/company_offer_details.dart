import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/home/_shared/models/employee_offer_to_company.dart';

class CompanyOfferDetails {
  late JobAdvertisement jobAdvertisement;
  List<EmployeeOfferToCompany> employeeOffers = [];

  CompanyOfferDetails.fromJson(Map map) {
    jobAdvertisement = JobAdvertisement.fromJson(map);
    employeeOffers = (map['offers'] as List).map<EmployeeOfferToCompany>((e) => EmployeeOfferToCompany.fromJson(e)).toList();
  }
}
