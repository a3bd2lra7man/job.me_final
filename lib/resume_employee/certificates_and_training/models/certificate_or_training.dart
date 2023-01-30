class CertificateOrTraining {
  int? id;
  late String name;
  late String field;
  late String providerName;
  late String date;
  late String description;

  CertificateOrTraining({
    required this.name,
    required this.field,
    required this.providerName,
    required this.date,
    required this.description,
  });

  CertificateOrTraining.fromJson(Map map) {
    id = map['id'];
    name = map['name'];
    field = map['field'];
    providerName = map['side'];
    date = map['date'];
    description = map['description'];
  }

  Map<String, dynamic> toJson() => {
        'id':id,
        'name': name,
        'field': field,
        'side': providerName,
        'date': date,
        'description': description,
      };

  static List<CertificateOrTraining> getListOfCertificatesOrTrainings(List? list){
    return list?.map((e) => CertificateOrTraining.fromJson(e)).toList() ?? [];
  }
}
