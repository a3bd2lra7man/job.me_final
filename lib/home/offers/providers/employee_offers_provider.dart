import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/home/offers/models/employee_offer.dart';
import 'package:job_me/home/offers/services/employee_offers_fetcher.dart';

class EmployeeOffersProvider extends ChangeNotifier {
  BuildContext context;

  EmployeeOffersProvider(this.context);

  final EmployeeOffersFetcher _offersFetcher = EmployeeOffersFetcher();
  final List<EmployeeOffer> offers = [];
  bool _isFirstLoading = false;
  bool _isPaginationLoading = false;

  bool get isFirstLoading => _isFirstLoading;


  bool get isPaginationLoading => _isPaginationLoading;

  Future getNextOffers() async {
    if (_checkIfPaginationReachEnd()) return;
    var isFirstLoading = _getIfThisPaginationLoadingOrTheFirstTime();
    _notify(loading: true, firstTime: isFirstLoading);

    try {
      var offers = await _offersFetcher.getNextOffers();
      this.offers.addAll(offers);
      if (this.offers.isEmpty) {
        _toastNoEnteredDataYet();
      } else if (_offersFetcher.didReachEnd) {
        _toastThatListReachEnd();
      }
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    _notify(loading: false, firstTime: isFirstLoading);
  }

  bool _checkIfPaginationReachEnd() {
    if (_offersFetcher.didReachEnd) {
      _toastThatListReachEnd();
      return true;
    }
    return false;
  }

  bool _getIfThisPaginationLoadingOrTheFirstTime() {
    bool isFirstTime = offers.isEmpty;
    return isFirstTime;
  }

  _notify({required bool loading, required bool firstTime}) {
    if (firstTime) {
      _isFirstLoading = loading;
    } else {
      _isPaginationLoading = loading;
    }
    notifyListeners();
  }

  _toastThatListReachEnd() {
    showSnackBar(body: context.translate('no_more_data'));
  }

  _toastNoEnteredDataYet() {
    showSnackBar(body: context.translate('no_entered_data_yet'));
  }
}
