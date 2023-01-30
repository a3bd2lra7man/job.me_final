// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:job_me/home/offers/ui/screens/company_offers_page.dart';
import 'package:job_me/home/offers/ui/screens/employee_offers_page.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';

Widget OffersScreen() {
  var userRepo = UserRepository();
  if (userRepo.isEmployee()) {
    return EmployeeOffersScreen.init();
  } else {
    return CompanyOffersScreen.init();
  }
}
