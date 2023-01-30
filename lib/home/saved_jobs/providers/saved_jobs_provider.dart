import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/home/saved_jobs/services/saves_jobs_fetcher.dart';

class SavedJobsProvider extends ChangeNotifier {
  BuildContext context;

  SavedJobsProvider(this.context);

  final SavedJobsFetcher _savedJobsFetcher = SavedJobsFetcher();
  final List<JobAdvertisement> savedJobs = [];
  bool _isFirstLoading = false;
  bool _isPaginationLoading = false;

  bool get isFirstLoading => _isFirstLoading;

  bool get isPaginationLoading => _isPaginationLoading;

  Future getNextSavedJobs() async {
    if (_checkIfPaginationReachEnd()) return;
    var isFirstLoading = _getIfThisPaginationLoadingOrTheFirstTime();
    _notify(loading: true, firstTime: isFirstLoading);

    try {
      var savedJobs = await _savedJobsFetcher.getNextSavedJobs();
      this.savedJobs.addAll(savedJobs);
      if (this.savedJobs.isEmpty) {
        _toastNoEnteredDataYet();
      } else if (_savedJobsFetcher.didReachEnd) {
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
    if (_savedJobsFetcher.didReachEnd) {
      _toastThatListReachEnd();
      return true;
    }
    return false;
  }

  bool _getIfThisPaginationLoadingOrTheFirstTime() {
    bool isFirstTime = savedJobs.isEmpty;
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
