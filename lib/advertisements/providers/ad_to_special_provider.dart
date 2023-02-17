import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/advertisements/models/bought_coins_plan.dart';
import 'package:job_me/advertisements/services/ad_to_special_adder.dart';
import 'package:job_me/advertisements/services/bought_coins_plans_fetcher.dart';

class AdToSpecialProvider extends ChangeNotifier {
  BuildContext context;
  List<BoughtCoinsPlan> _transactions = [];

  List<BoughtCoinsPlan> get transactions => _transactions.where((element) => !element.isUsed()).toList();
  final TransactionsFetcher _transactionsFetcher = TransactionsFetcher();

  AdToSpecialProvider(this.context);

  final AdToSpecialAdder _adToSpecialAdder = AdToSpecialAdder();

  bool isLoading = false;

  Future addToSpecial({required JobAdvertisement jobAdvertisement, required BoughtCoinsPlan transaction}) async {
    try {
      await _adToSpecialAdder.addToSpecial(jobAdvertisement,transaction);
      return true;
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
  }

  Future getBoughtCoins() async {
    isLoading = true;
    notifyListeners();
    try {
      _transactions = await _transactionsFetcher.getBoughtCoinsPlans();
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    isLoading = false;
    notifyListeners();
  }
}
