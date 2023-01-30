import 'package:job_me/_shared/api/constants/base_url.dart';
import 'package:job_me/company_profile/company_department/models/company_department.dart';

class CompanyInfo {
  late int id;
  late String name;
  late String email;
  String? _photo;
  String? size;
  String? date;
  String? notes;
  String? field;
  List<CompanyDepartment> companyDepartments = [];


  String? get photo {
    if (_photo == null) return _photo;
    if (_photo!.startsWith('http')) return _photo;
    return "${BaseUrls.staticUrl()}/${_photo!}";
  }

  CompanyInfo.fromJson(Map map) {
    id = map['id'];
    name = map['name'];
    date = map['date'];
    field = map['employment'];
    size = map['size'];
    email = map['email'];
    notes = map['notes'];
    _photo = map['photo'];
    companyDepartments = CompanyDepartment.getListOfCompanyDepartment(map['subCompany']);
  }

}
