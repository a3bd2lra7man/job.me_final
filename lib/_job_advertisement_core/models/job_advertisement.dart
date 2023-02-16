import 'package:job_me/_shared/api/constants/base_url.dart';

class JobAdvertisement {
  late int id;
  late String title;
  late String description;
  late num yearsOfExperiences;
  late num workTime;
  late bool isSpecial;
  String? _name;
  int? userId;
  late String _publishTime;
  String? requirement;
  String? _image;
  int? categoryId;
  String? jobCountry;


  String? get userImage {
    if (_image == null) return _image;
    if (_image!.startsWith('http')) return _image;
    return "${BaseUrls.staticUrl()}/${_image!}";
  }

  String get userName => _name ?? "";

  String get publishTime => _publishTime;

  JobAdvertisement(
      {required this.title,
      required this.description,
      required this.yearsOfExperiences,
      required this.workTime,
        required this.categoryId,
      this.requirement});

  JobAdvertisement.fromJson(Map json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    yearsOfExperiences = json['yearsOfExperiences'];
    workTime = json['workTime'];
    isSpecial = json['isSpecial'] == 0 ? false : true;
    if (json['user'] != null) {
      _name = json['user']['fullname'];
      _image = json['user']['photo'];
      jobCountry = json['user']['country'];
      userId = json['user']['id'];
    }
    requirement = json['requirement'];
    _publishTime = json['updated_at'].toString().split('T')[0];
    if(json['category_id'] != null){
      categoryId = json['category_id'];
    }
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "workTime": workTime,
        "yearsOfExperiences": yearsOfExperiences,
        if (requirement != null) "requirement": requirement,
        'category_id':categoryId
      };
}
