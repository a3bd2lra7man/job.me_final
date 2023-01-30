import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';

enum OfferStatus {
  refused,
  accepted,
  inProgress,
  unknown;

  static OfferStatus fromInt(int status) {
    if (status == 2) return OfferStatus.inProgress;
    if (status == 1) return OfferStatus.accepted;
    if (status == 0) return OfferStatus.refused;
    return OfferStatus.unknown;
  }

  String toReadableString(){
    switch(this){

      case refused:
          return 'refused';
      case accepted:
        return 'accepted';
      case OfferStatus.inProgress:
        return 'in_progress';
      case OfferStatus.unknown:
        return 'unknown';
    }
  }
}

class EmployeeOffer extends JobAdvertisement{
  late int jobId;
  late int publisherID;
  late OfferStatus offerStatus;

  EmployeeOffer.fromJson(Map json) :super.fromJson(json) {
    userId = json['user_id'];
    jobId = json['pivot']['ads_jobs_id'];
    publisherID = json['pivot']['ads_jobs_id'];
    offerStatus = OfferStatus.fromInt(json['status']);
  }

  bool isAccepted() {
    return true;
  }
}
