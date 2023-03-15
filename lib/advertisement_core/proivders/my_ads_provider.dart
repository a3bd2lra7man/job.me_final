import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/advertisement_core/services/job_advertisement_deleter.dart';
import 'package:job_me/advertisement_core/services/my_ads_fetcher.dart';


class MyAdsProvider extends ChangeNotifier {
  BuildContext context;

  MyAdsProvider(this.context);


  final MyAdsFetcher _myAdsFetcher = MyAdsFetcher();
  final _adDeleter = JobAdvertisementDeleter();

  final List<JobAdvertisement> myAds = [];
  bool _isFirstLoading = false;
  bool _isPaginationLoading = false;

  bool get isFirstLoading => _isFirstLoading;

  bool get isPaginationLoading => _isPaginationLoading;

  int? _currentTransactionId;
  bool isTransactionLoading( int id) => id == _currentTransactionId;

  Future refreshAndGetMyAds() async {
    _myAdsFetcher.refreshPagination();
    await getNextMyAds();
  }

  Future getCategories() async {
    _isFirstLoading = true;
    notifyListeners();
  }

  Future getNextMyAds() async {
    if (_checkIfPaginationReachEnd()) return;
    var isFirstLoading = _getIfThisPaginationLoadingOrTheFirstTime();
    _notify(loading: true, firstTime: isFirstLoading);

    try {
      var myAds = await _myAdsFetcher.getNextMyAds();
      if (_myAdsFetcher.didReachEnd) _toastThatListReachEnd();
      this.myAds.addAll(myAds);
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    _notify(loading: false, firstTime: isFirstLoading);
  }

  bool _checkIfPaginationReachEnd() {
    if (_myAdsFetcher.didReachEnd) {
      _toastThatListReachEnd();
      return true;
    }
    return false;
  }

  bool _getIfThisPaginationLoadingOrTheFirstTime() {
    bool isFirstTime = myAds.isEmpty;
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

  Future deleteAnAd(JobAdvertisement jobAdvertisement) async {
    _currentTransactionId = jobAdvertisement.id;
    notifyListeners();
    try {
      await _adDeleter.deleteAnAdJob(jobAdvertisement);
      notifyListeners();
      _myAdsFetcher.refreshPagination();
      myAds.clear();
      _currentTransactionId = null;
      await getNextMyAds();
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    _notify(loading: false, firstTime: isFirstLoading);
  }
}
