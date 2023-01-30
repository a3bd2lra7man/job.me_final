class Skill {
  int? id;
  late String name;

  Skill({
    required this.name,
  });

  Skill.fromJson(Map map) {
    id = map['id'];
    name = map['name'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };


  static List<Skill> getListOfSkills(List? list){
    return list?.map((e) => Skill.fromJson(e)).toList() ?? [];
  }
}
