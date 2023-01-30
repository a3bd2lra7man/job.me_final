import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/user/_user_core/models/user.dart';

class JobAdWithAppliers {
  late JobAdvertisement jobAdvertisement;
  List<User> users = [];

  JobAdWithAppliers.fromJson(Map map) {
    jobAdvertisement = JobAdvertisement.fromJson(map);
    users = (map['offers'] as List).map<User>((e) => User.fromJson(e)).toList();
  }

  bool isEmployeeApplied(int employeeId) {
    return users.where((user) => user.id == employeeId).isNotEmpty;
  }
}
