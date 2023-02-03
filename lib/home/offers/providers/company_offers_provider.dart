import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/home/offers/models/company_offer.dart';
import 'package:job_me/home/offers/services/comapny_offers_fetcher.dart';

class CompanyOffersProvider extends ChangeNotifier {
  BuildContext context;

  CompanyOffersProvider(this.context);

  final CompanyOffersFetcher _offersFetcher = CompanyOffersFetcher();
  final List<CompanyOffer> offers = [];
  bool _isFirstLoading = false;
  bool _isPaginationLoading = false;
  bool _isOffersEmpty = false;

  bool get isFirstLoading => _isFirstLoading;

  bool get isPaginationLoading => _isPaginationLoading;
  bool get isOffersEmpty => _isOffersEmpty;

  Future getNextOffers() async {
    if (_checkIfPaginationReachEnd()) return;
    _isOffersEmpty = false;
    var isFirstLoading = _getIfThisPaginationLoadingOrTheFirstTime();
    _notify(loading: true, firstTime: isFirstLoading);

    try {
      var offers = await _offersFetcher.getNextOffers();
      this.offers.addAll(offers);
      if (this.offers.isEmpty) {
        _isOffersEmpty = true;
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
}
