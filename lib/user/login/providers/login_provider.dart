import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/home/home/ui/screens/home_page.dart';
import 'package:job_me/user/_user_core/models/roles.dart';
import 'package:job_me/user/_user_core/models/user.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';
import 'package:job_me/user/login/services/apple_signing.dart';
import 'package:job_me/user/login/services/facebook_signing.dart';
import 'package:job_me/user/login/services/google_signin.dart';
import 'package:job_me/user/login/models/login_credentials.dart';
import 'package:job_me/user/login/services/login_submitter.dart';
import 'package:job_me/user/login/ui/widget/you_are_not_company_bottom_sheet.dart';
import 'package:job_me/user/login/ui/widget/you_are_not_employee_bottom_sheet.dart';
import 'package:provider/provider.dart';

class LoginProvider extends ChangeNotifier {
  BuildContext context;

  LoginProvider(this.context);

  final LoginSubmitter _loginSubmitter = LoginSubmitter();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isNormalLoginLoading = false;
  bool isFacebookLoginLoading = false;
  bool isAppleLoginLoading = false;
  bool isGoogleLoginLoading = false;

  // MARK: login functions

  void loginWithRole(Roles role) async {
    isNormalLoginLoading = true;
    notifyListeners();
    try {
      var loginCredentials = _createLoginCredentials();
      var user = await _loginSubmitter.login(loginCredentials);
      _checkUserRoleThenGoToHomePage(user, role);
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    isNormalLoginLoading = false;
    notifyListeners();
  }

  _createLoginCredentials() {
    var name = nameController.text;
    var password = passwordController.text;
    return LoginCredentials(username: name, password: password);
  }

  void googleSocialLogin(Roles role) async {
    isGoogleLoginLoading = true;
    notifyListeners();
    try {
      var socialLogin = await GoogleAppSignIn().googleSignIn(role);
      var user = await _loginSubmitter.socialLogin(socialLogin);
      await _checkUserRoleThenGoToHomePage(user, role);
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    isGoogleLoginLoading = false;
    notifyListeners();
  }

  void facebookSocialLogin(Roles role) async {
    isFacebookLoginLoading = true;
    notifyListeners();
    try {
      var socialLogin = await FacebookSignIn().facebookLogin(role);
      var user = await _loginSubmitter.socialLogin(socialLogin);
      await _checkUserRoleThenGoToHomePage(user, role);
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    isFacebookLoginLoading = false;
    notifyListeners();
  }

  void appleSocialLogin(Roles role) async {
    isAppleLoginLoading = true;
    notifyListeners();
    try {
      var socialLogin = await AppleSignIn().login(context, role);
      if (socialLogin == null) {
        isAppleLoginLoading = false;
        notifyListeners();
        return;
      }
      var user = await _loginSubmitter.socialLogin(socialLogin);
      await _checkUserRoleThenGoToHomePage(user, role);
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    isAppleLoginLoading = false;
    notifyListeners();
  }

  Future _checkUserRoleThenGoToHomePage(User user, Roles selectedRole) async {
    if (user.role == selectedRole) {
      await saveUserThenGoToHomePage(user);
      return;
    }
    if (user.role == Roles.searcherForJob) {
      Get.bottomSheet(ChangeNotifierProvider.value(value: this,child: YouAreNotCompanyBottomSheet(user: user)));
    } else {
      Get.bottomSheet(ChangeNotifierProvider.value(value: this,child: YouAreNotEmployeeBottomSheet(user: user)));
    }
  }

  Future saveUserThenGoToHomePage(User user) async {
    await UserRepository().saveUser(user);
    Get.offAll(HomePage.init(), transition: Transition.downToUp);
  }

// MARK: validators

  String? isNameValid(String? name) {
    if (name != null && name.isNotEmpty) {
      return null;
    } else {
      return context.translate('enter_valid_name');
    }
  }

  String? isPasswordValid(String? password) {
    if (password != null && password.length >= 8) {
      return null;
    } else {
      return context.translate('enter_valid_password');
    }
  }
}
