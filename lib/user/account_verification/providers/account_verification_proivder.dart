import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';
import 'package:job_me/user/account_verification/services/account_activator.dart';
import 'package:job_me/user/account_verification/services/phone_number_verifier.dart';

import '../ui/screen/account_activated_successfully_screen.dart';

class AccountVerificationProvider extends ChangeNotifier {
  final BuildContext _context;

  AccountVerificationProvider(this._context);

  final UserRepository _userRepository = UserRepository();
  final AccountActivator _accountActivator = AccountActivator();
  final PhoneNumberVerifier _numberVerifier = PhoneNumberVerifier();

  String getUserEmail() => _userRepository.getUser().email;

  bool isTransactionLoading = false;
  bool isCodeSent = false;

  void onSendActivationCode(String phone) async {
    isTransactionLoading = true;
    notifyListeners();

    await _numberVerifier.sendCodeToPhoneNumber(_context, phone, codeSent: () {
      isCodeSent = true;
      notifyListeners();
    }, onFailed: (e) {
      isCodeSent = false;
      showSnackBar(body: _context.translate(e.userReadableMessage));
    });
    isTransactionLoading = false;
    notifyListeners();
  }

  void activateAccount(String phone, String code) async {
    isTransactionLoading = true;
    notifyListeners();
    await _numberVerifier.assertCodeIsRight(_context, code, onSuccess: () async {
      await informServerFirebaseVerificationIsDoneSuccessfully(phone);
    }, onFailed: (e) {
      showSnackBar(body: _context.translate(e.userReadableMessage));
      isTransactionLoading = false;
      notifyListeners();
    });
  }

  Future informServerFirebaseVerificationIsDoneSuccessfully(String phone) async {
    isTransactionLoading = true;
    notifyListeners();
    try {
      var user = await _accountActivator.verifyCode(phone);
      _userRepository.saveUser(user);
      Get.offAll(() => const AccountActivatedSuccessfullyScreen());
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: _context.translate(e.userReadableMessage));
    }
    isTransactionLoading = false;
    notifyListeners();
  }
}
