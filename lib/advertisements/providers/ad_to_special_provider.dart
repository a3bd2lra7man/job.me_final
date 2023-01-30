import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/advertisements/models/transactions.dart';
import 'package:job_me/advertisements/services/ad_to_special_adder.dart';
import 'package:job_me/advertisements/services/transactions_and_orders_fetcher.dart';

class AdToSpecialProvider extends ChangeNotifier {
  BuildContext context;
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions.where((element) => !element.isUsed()).toList();
  final TransactionsFetcher _transactionsFetcher = TransactionsFetcher();

  AdToSpecialProvider(this.context);

  final AdToSpecialAdder _adToSpecialAdder = AdToSpecialAdder();

  bool isLoading = false;

  Future addToSpecial({required JobAdvertisement jobAdvertisement, required Transaction transaction}) async {
    try {
      await _adToSpecialAdder.addToSpecial(jobAdvertisement,transaction);
      return true;
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
  }

  Future getTransactions() async {
    isLoading = true;
    notifyListeners();

    try {
      _transactions = await _transactionsFetcher.getTransactions();
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    isLoading = false;
    notifyListeners();
  }
}
