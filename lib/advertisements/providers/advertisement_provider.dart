import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/advertisements/services/balance_fetcher.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';

class AdvertisementOffersProvider extends ChangeNotifier {
  BuildContext context;
  final _userRepository = UserRepository();
  num? userBalance;

  AdvertisementOffersProvider(this.context);

  // MARK: get advertisement offers

  bool isLoading = true;
  final BalanceFetcher _offersFetcher = BalanceFetcher();

  Future getAdvertisementData() async {
    isLoading = true;
    notifyListeners();

    try {
      userBalance = await _offersFetcher.getAdvertisementsOffers();
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    isLoading = false;
    notifyListeners();
  }

  // MARK: Getters

  String getUsersName() => _userRepository.getUser().fullName;

  num getUsersCredit() => userBalance ?? 0;
}
