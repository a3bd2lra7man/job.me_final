import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:job_me/home/job_details/ui/screens/employee_resume_screen.dart';
import 'package:job_me/home/job_details/ui/screens/job_details_screen.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';
import 'package:job_me/user/login/ui/screens/company_login_screen.dart';
import 'package:job_me/user/login/ui/screens/employee_login_screen.dart';

enum HomePages { saved, main, offers, account }

class HomePageProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  bool isUserLoggedIn() => _userRepository.isUserLoggedIn();

  String getUserName() => isUserLoggedIn() ? _userRepository.getUser().fullName : "Guest";

  String getUserEmail() => isUserLoggedIn() ? _userRepository.getUser().email : "";

  HomePages _selectedHomePages = HomePages.main;

  HomePages get selectedPage => _selectedHomePages;

  void changeSelectedPageTo(HomePages page) {
    _selectedHomePages = page;
    notifyListeners();
  }

  bool isPageSelectedPage(HomePages page) {
    return page == _selectedHomePages;
  }

  bool isUserActivated() {
    if (!_userRepository.isUserLoggedIn()) return false;
    return _userRepository.getUser().verified;
  }

  bool isUserEmployee() {
    return _userRepository.isEmployee();
  }

  bool isUserCompany() {
    return !_userRepository.isEmployee();
  }

  /*
  this app has tow users type
   1. employee
   2. company
   and most of the logic is the same and there is no difference except two major difference
   1. each user should tell the api what type of user he is, and to do that you need to add a query parameter to the url got calling
   2. employee when browsing jobs he will receive jobs posted by companies and vice versa, so when job card got clicked each user will go to the appropriate screen
  */

  void onJobCardClicked(int jobId) {
    var isUserIsEmployee = _userRepository.isEmployee();

    if (isUserIsEmployee) {
      Get.to(JobDetailsScreen.init(jobId: jobId));
    } else {
      Get.to(EmployeeResumeScreen.init(employeeAdId: jobId));
    }
  }

  void onGuestClickOnGoToLogin() {
    var isUserIsEmployee = _userRepository.isEmployee();

    if (isUserIsEmployee) {
      Get.to(EmployeeLoginScreen.init());
    } else {
      Get.to(CompanyLoginScreen.init());
    }
  }
}
