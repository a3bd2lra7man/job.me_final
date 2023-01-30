import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/buy_coins/models/buy_coins_model.dart';
import 'package:job_me/buy_coins/models/buy_coins_offer.dart';
import 'package:job_me/buy_coins/services/offers_and_balance_fetcher.dart';
import 'package:job_me/buy_coins/services/payment_gateway_url_generator.dart';
import 'package:job_me/buy_coins/services/payment_status_fetcher.dart';
import 'package:job_me/buy_coins/ui/screens/failed_buy_coins_screen.dart';
import 'package:job_me/buy_coins/ui/screens/success_buy_coins_screen.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';

class CoinsProvider extends ChangeNotifier {
  final BuildContext context;

  bool isToSaveNewCard = false;
  final _paymentGateWayUrlGenerator = PaymentGatewayUrlGenerator();
  final _userRepository = UserRepository();
  final _paymentStatusFetcher = PaymentStatusFetcher();
  final OffersAndBalanceFetcher _offersAndBalanceFetcher = OffersAndBalanceFetcher();

  BuyCoinsModel? buyCoinsModel;

  CoinsProvider(this.context);

  bool isLoading = true;

  Future generateBuyUrl(BuyCoinsOffer offer) async {
    try {
      var url = await _paymentGateWayUrlGenerator.generateLink(offer);
      return url;
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
  }

  Future getUserBalanceAndBuyCoinsOffer() async {
    isLoading = true;
    notifyListeners();

    try {
      buyCoinsModel = await _offersAndBalanceFetcher.getCoinsOffersWithBalance();
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    isLoading = false;
    notifyListeners();
  }

  Future checkPaymentStatus(String paymentId, String coinsCount) async {
    isLoading = true;
    notifyListeners();
    try {
      var isSuccess = await _paymentStatusFetcher.isPaymentSuccess(paymentId);
      if (!isSuccess) Get.to(() => const FailedBuyCoinsScreen());
      if (isSuccess) Get.off(() => SuccessfullyBuyCoinsScreen(coinsCount: coinsCount));
    } on ServerSentException  {
      Get.to(() => const FailedBuyCoinsScreen());
    } on AppException  {
      Get.to(() => const FailedBuyCoinsScreen());
    }
    isLoading = false;
    notifyListeners();
  }

  // MARK: controllers

  final cardNumberController = TextEditingController();
  final nameController = TextEditingController();
  final ccvController = TextEditingController();
  DateTime? expireDate;

  num getUsersCredit() => buyCoinsModel?.balance ?? 0;

  String getUsersName() => _userRepository.getUser().fullName;

  // MARK: validators

  String? isCardNumberValid(String? string) {
    return string != null && string.length == 16 ? null : context.translate('please_enter_valid_card_number');
  }

  String? isCvvValid(String? string) {
    return string != null && string.length == 3 ? null : context.translate('please_enter_valid_cvv');
  }

  String? isNameValid(String? string) {
    return string != null && string.contains(' ') ? null : context.translate('please_enter_valid_card_name');
  }

  void setExpireDate(DateTime date) {
    expireDate = date;
    notifyListeners();
  }

  void changeIsToSaveNewCard() {
    isToSaveNewCard = !isToSaveNewCard;
    notifyListeners();
  }
}
