import 'package:job_me/_shared/api/entities/image_file.dart';

enum Gender {
  male,
  female;

  static Gender fromBoolean({required bool isMan}) {
    return isMan ? male : female;
  }

  String toRawString() {
    switch (this) {
      case male:
        return 'ذكر';
      case female:
        return 'انثى';
    }
  }
}

class PersonalInfoData {
  String country;
  String phone;
  Gender gender;
  String dateOfBirth;
  ImageFile? imageFile;

  PersonalInfoData({
    required this.country,
    required this.phone,
    required this.gender,
    required this.dateOfBirth,
    required this.imageFile,
  });

  Map<String, dynamic> toJson() {
    return {
      "country": country,
      "phone": phone,
      "gender": gender.toRawString(),
      "dob": dateOfBirth,
    };
  }
}
