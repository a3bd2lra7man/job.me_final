import 'package:job_me/user/_user_core/exceptions/unknown_role.dart';

enum Roles {
  searcherForJob,
  jobCompany;

  static Roles fromInt(int role) {
    if (role == 2) return Roles.searcherForJob;
    if (role == 3) return Roles.jobCompany;
    throw UnknownRole();
  }

  int toInt() {
    switch (this) {
      case searcherForJob:
        return 2;
      case jobCompany:
        return 3;
    }
  }
}
