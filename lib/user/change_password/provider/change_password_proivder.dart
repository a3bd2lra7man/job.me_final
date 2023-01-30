import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/user/change_password/services/change_password_executor.dart';
import 'package:job_me/user/change_password/ui/password_change_successfully_screen.dart';

class ChangePasswordProvider extends ChangeNotifier {
  BuildContext context;

  ChangePasswordProvider(this.context);

  final oldPassword = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  final _changePasswordExecutor = ChangePasswordExecutor();
  bool isLoading = false;

  Future sendNewPassword() async {
    isLoading = true;
    notifyListeners();
    try {
      await _changePasswordExecutor.sendNewPassword(
          oldPassword.text, passwordController.text, passwordConfirmationController.text);
      Get.off(() => const PasswordChangedSuccessfullyScreen());
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
}
