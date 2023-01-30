import 'package:job_me/_shared/api/constants/base_url.dart';
import 'package:job_me/user/_user_core/models/roles.dart';

class User {
  late int id;
  late String email;
  late String username;
  late String fullName;
  late Roles role;
  late String token;
  String? phone;
  String? gender;
  String? _photo;
  String? _emailVerified;
  String? country;
  String? dateOfBirth;
  String? _phoneVerified;

  bool get verified => _phoneVerified != null;

  String? get image {
    if (_photo == null) return _photo;
    if (_photo!.startsWith('http')) return _photo;
    return "${BaseUrls.staticUrl()}/${_photo!}";
  }

  User.fromJson(Map json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    fullName = json['fullname'];
    phone = json['phone'];
    gender = json['gender'];
    _photo = json['photo'];
    token = json['token'] ?? "";
    role = Roles.fromInt(json['role']);
    _emailVerified = json['email_verified_at'];
    _phoneVerified = json['sms_verified_at'];
    country = json['country'];
    dateOfBirth = json['dob'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = id;
    json['email'] = email;
    json['username'] = username;
    json['fullname'] = fullName;
    json['phone'] = phone;
    json['gender'] = gender;
    json['photo'] = _photo;
    json['role'] = role.toInt();
    json['token'] = token;
    json['email_verified_at'] = _emailVerified;
    json['sms_verified_at'] = _phoneVerified;
    json['dob'] = dateOfBirth;
    json['country'] = country;
    return json;
  }


}
