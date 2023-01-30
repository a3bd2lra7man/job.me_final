// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:job_me/home/main/ui/screens/_company_main_page.dart';
import 'package:job_me/home/main/ui/screens/_employee_main_page.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';

Widget MainPage() {
  var userRepo = UserRepository();

  if (userRepo.isEmployee()) {
    return EmployeeMainPage.init();
  } else {
    return CompanyMainPage.init();
  }
}
