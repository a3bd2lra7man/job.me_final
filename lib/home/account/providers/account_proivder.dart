import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_main/ui/splash_screen.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/home/account/services/account_deleter.dart';
import 'package:job_me/home/account/services/balance_fetcher.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';

class AccountProvider extends ChangeNotifier {
  BuildContext context;

  AccountProvider(this.context);

  num _userBalance = 0;

  num get userBalance => _userBalance;

  bool isLoading = false;

  final _accountDeleter = AccountDeleter();
  final _balanceFetcher = BalanceFetcher();
  final UserRepository _userRepository = UserRepository();

  Future getUserBalance() async {
    try {
      var balance = await _balanceFetcher.getUserBalnce();
      _userBalance = balance;
      notifyListeners();
    } catch (_) {}
  }

  Future deleteAccount() async {
    isLoading = true;
    notifyListeners();

    try {
      await _accountDeleter.deleteAccount();
      await logOut();
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    isLoading = false;
    notifyListeners();
  }

  Future logOut() async {
    await _userRepository.removeUser();
    Get.offAll(const SplashScreen());
  }

  String? getUserImage() => _userRepository.isUserLoggedIn() ? _userRepository.getUser().image : null;
}
