import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/_shared/api/constants/base_url.dart';


class JobAdsDetails extends JobAdvertisement {
  late String name;
  late bool isApplied;
  late bool isSaved;
  String? _image;

  String? get image {
    if (_image == null) return _image;
    if (_image!.startsWith('http')) return _image;
    return "${BaseUrls.staticUrl()}/${_image!}";
  }

  JobAdsDetails.fromJson(Map json) : super.fromJson(json) {
    name = json['user']['fullname'];
    _image = json['user']['photo'];
    requirement = json['requirement'];
    jobCountry = json['user']['country'];
    isApplied = json['isApply'];
    userId = json['user']['id'];
    isSaved = json['isSaved'] == 0 ? false : true;
  }
}
