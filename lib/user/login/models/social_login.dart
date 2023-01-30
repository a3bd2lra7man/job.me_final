import 'package:job_me/user/_user_core/models/roles.dart';

enum SocialLoginType {
  google,
  facebook,
  apple;

  String toRawString() {
    switch (this) {
      case google:
        return "google";
      case facebook:
        return "facebook";
      case SocialLoginType.apple:
        return "apple";
    }
  }
}

class SocialLoginModel {
  String email;
  SocialLoginType socialType;
  String socialId;
  String photo;
  String fullName;
  Roles role;

  SocialLoginModel(
      {required this.email,
      required this.socialType,
      required this.socialId,
      required this.photo,
      required this.fullName,
      required this.role});

  Map<String, dynamic> toJson() => {
        "email": email,
        "social_id": socialId,
        "social_type": socialType.toRawString(),
        if (photo.isNotEmpty) "photo": photo,
        "fullname": fullName,
        "role": role.toInt()
      };
}
