import 'package:job_me/resume_core/models/resume.dart';

enum EmployeeApplicationStatus {
  accepted,
  underProcess,
  refused;

  static EmployeeApplicationStatus fromInt(int status) {
    if (status == 0) return EmployeeApplicationStatus.refused;
    if (status == 1) return EmployeeApplicationStatus.accepted;
    if (status == 2) return EmployeeApplicationStatus.underProcess;
    return EmployeeApplicationStatus.underProcess;
  }
}

class EmployeeResumeWithApplyStatusModel extends Resume {
  late EmployeeApplicationStatus employeeApplicationStatus;

  EmployeeResumeWithApplyStatusModel.fromJson(Map map) : super.fromJson(map) {
    employeeApplicationStatus = EmployeeApplicationStatus.fromInt(map['status_job']);
  }

  isAccepted() {
    return employeeApplicationStatus == EmployeeApplicationStatus.accepted;
  }

  isUnderProcess() {
    return employeeApplicationStatus == EmployeeApplicationStatus.underProcess;
  }
}
