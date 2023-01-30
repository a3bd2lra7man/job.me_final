class CompanyDepartment {
  int? id;
  late String country;
  late String city;
  late num employeesCount;

  CompanyDepartment({
    required this.country,
    required this.city,
    required this.employeesCount,
  });

  CompanyDepartment.fromJson(Map map) {
    id = map['id'];
    country = map['country'];
    city = map['city'];
    employeesCount = map['employees'];
  }

  Map<String, dynamic> toJson() => {
        'id':id,
        'country': country,
        'city': city,
        'employees': employeesCount,
      };

  static List<CompanyDepartment> getListOfCompanyDepartment(List? list){
    return list?.map((e) => CompanyDepartment.fromJson(e)).toList() ?? [];
  }
}
