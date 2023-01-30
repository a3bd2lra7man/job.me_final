class Experience {
  int? id;
  late String enterpriseName;
  late String field;
  late String jobName;
  late String startDate;
  late String endDate;
  late String description;
  late String country;

  Experience({
    required this.enterpriseName,
    required this.field,
    required this.jobName,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.country,
  });

  Experience.fromJson(Map map) {
    id = map['id'];
    enterpriseName = map['enterprise'];
    field = map['field'];
    jobName = map['job'];
    startDate = map['date_in'];
    endDate = map['date_to'];
    description = map['desc_job'];
    country = map['country'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'enterprise': enterpriseName,
        'field': field,
        'job': jobName,
        'date_in': startDate,
        'date_to': endDate,
        'desc_job': description,
        'country': country,
      };

  static List<Experience> getListOfExperiences(List? list){
    return list?.map((e) => Experience.fromJson(e)).toList() ?? [];
  }
}
