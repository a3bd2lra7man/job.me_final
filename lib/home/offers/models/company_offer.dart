import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';

class CompanyOffer extends JobAdvertisement {
  late num numberOfOffers;

  CompanyOffer.fromJson(Map map) : super.fromJson(map) {
    numberOfOffers = map['nbrOffers'] ?? 0;
  }
}
