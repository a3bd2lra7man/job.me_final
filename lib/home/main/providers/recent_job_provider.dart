import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/home/main/services/recent_ads_jobs_fetcher.dart';

class RecentJobProvider extends ChangeNotifier {
  BuildContext context;

  RecentJobProvider(this.context);

  final RecentAdsJobsFetcher _jobsFetcher = RecentAdsJobsFetcher();
  List<JobAdvertisement> jobs = [];
  bool _isFirstLoading = true;
  bool _isPaginationLoading = false;

  bool get isFirstLoading => _isFirstLoading;

  bool get isPaginationLoading => _isPaginationLoading;

  Future getNextJobs() async {
    if (_checkIfPaginationReachEnd()) return;
    var isFirstLoading = _getIfThisPaginationLoadingOrTheFirstTime();
    _notify(loading: true, firstTime: isFirstLoading);

    try {
      var jobs = await _jobsFetcher.getNextJobs();
      if (_jobsFetcher.didReachEnd && !_isFirstLoading) _toastThatListReachEnd();
      this.jobs.addAll(jobs);
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    _notify(loading: false, firstTime: isFirstLoading);
  }

  bool _checkIfPaginationReachEnd() {
    if (_jobsFetcher.didReachEnd) {
      _toastThatListReachEnd();
      return true;
    }
    return false;
  }

  bool _getIfThisPaginationLoadingOrTheFirstTime() {
    bool isFirstTime = jobs.isEmpty;
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
