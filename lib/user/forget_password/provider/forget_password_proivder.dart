import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/user/forget_password/services/forget_password_executor.dart';
import 'package:job_me/user/forget_password/ui/password_change_successfully_screen.dart';

class ForgetPasswordProvider extends ChangeNotifier {
  BuildContext context;

  ForgetPasswordProvider(this.context);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  final ForgetPasswordExecutor _forgetPasswordExecutor = ForgetPasswordExecutor();

  String verificationCode = "";
  bool isLoading = false;
  bool isEmailFound = false;
  bool isCodeChecked = false;

  bool get codeNotCheckedYet => !isCodeChecked;

  Future checkEmail() async {
    longOperation(() async {
      await _forgetPasswordExecutor.checkEmail(emailController.text);
      isEmailFound = true;
    });
  }

  Future checkCode() async {
    longOperation(() async {
      await _forgetPasswordExecutor.checkCode(verificationCode);
      isCodeChecked = true;
    });
  }

  Future sendNewPassword() async {
    longOperation(() async {
      await _forgetPasswordExecutor.sendNewPassword(
          verificationCode, passwordController.text, passwordConfirmationController.text);
      Get.offAll(const PasswordChangedSuccessfullyScreen());
    });
  }

  void longOperation(Future Function() doo) async {
    isLoading = true;
    notifyListeners();
    try {
      await doo();
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    isLoading = false;
    notifyListeners();
  }

  // MARK: validators

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

  void onCodeChange(String value) {
    verificationCode = value;
  }
}
