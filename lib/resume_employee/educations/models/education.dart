class Education {
  int? id;
  late String universityName;
  late String specialization;
  late String level;
  late String startDate;
  late String endDate;
  late String mark;
  late String country;

  Education({
    required this.universityName,
    required this.specialization,
    required this.level,
    required this.startDate,
    required this.endDate,
    required this.mark,
    required this.country,
  });

  Education.fromJson(Map map) {
    id = map['id'];
    universityName = map['university'];
    specialization = map['specialization'];
    level = map['level'];
    startDate = map['date_in'];
    endDate = map['date_to'];
    mark = map['mark'];
    country = map['country'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'university': universityName,
        'specialization': specialization,
        'level': level,
        'date_in': startDate,
        'date_to': endDate,
        'mark': mark,
        'country': country,
      };

  static List<Education> getListOfEducations(List? list){
    return list?.map((e) => Education.fromJson(e)).toList() ?? [];
  }
}
