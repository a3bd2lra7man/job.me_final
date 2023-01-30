class LoginCredentials {
  String username;
  String password;

  LoginCredentials({required this.username, required this.password});

  Map<String, dynamic> toJson() => {"username": username, "password": password};
}
