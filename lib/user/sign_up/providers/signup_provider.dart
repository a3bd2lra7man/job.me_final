import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/exceptions/known_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/home/home/ui/screens/home_page.dart';
import 'package:job_me/user/_user_core/models/roles.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';
import 'package:job_me/user/sign_up/models/signup_credentials.dart';
import 'package:job_me/user/sign_up/services/signup_submitter.dart';

class SignUpProvider extends ChangeNotifier {
  BuildContext context;

  SignUpProvider(this.context);

  final SignUpSubmitter _signupSubmitter = SignUpSubmitter();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordConfirmationController = TextEditingController();

  bool isLoading = false;

  // MARK: login functions

  void signUpJobEmployee() async {
    _notify(loading: true);
    try {
      var signupCredentials = _createSignupCredentials(Roles.searcherForJob);
      var user = await _signupSubmitter.signup(signupCredentials);
      await UserRepository().saveUser(user);
      Get.offAll(HomePage.init(), transition: Transition.downToUp);
    } on KnownException catch (e) {
      showSnackBar(body: e.userReadableMessage);
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    _notify(loading: false);
  }

  void signUpCompany() async {
    _notify(loading: true);
    try {
      var signupCredentials = _createSignupCredentials(Roles.jobCompany);
      var user = await _signupSubmitter.signup(signupCredentials);
      await UserRepository().saveUser(user);
      Get.offAll(HomePage.init(), transition: Transition.downToUp);
    } on KnownException catch (e) {
      showSnackBar(body: e.userReadableMessage);
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    _notify(loading: false);
  }

  SignupCredentials _createSignupCredentials(Roles role) {
    var name = nameController.text;
    var fullName = fullNameController.text;
    var email = emailController.text;
    var password = passwordController.text;
    var passwordConfirmation = passwordConfirmationController.text;
    return SignupCredentials(
        username: name,
        password: password,
        fullName: fullName,
        email: email,
        passwordConfirmation: passwordConfirmation,
        role: role);
  }

  _notify({required bool loading}) {
    isLoading = loading;
    notifyListeners();
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

  String? isValidEmail(String? email) {
    return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                .hasMatch(email ?? "") ==
            true
        ? null
        : context.translate('enter_valid_email');
  }
}
