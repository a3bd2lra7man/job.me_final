import 'package:job_me/user/_user_core/models/roles.dart';

class SignupCredentials {
  String username;
  String fullName;
  String email;
  String password;
  String passwordConfirmation;
  Roles role;

  SignupCredentials({
    required this.username,
    required this.fullName,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "fullname": fullName,
        "email": email,
        "password_confirmation": passwordConfirmation,
        "role": role.toInt(),
      };
}
