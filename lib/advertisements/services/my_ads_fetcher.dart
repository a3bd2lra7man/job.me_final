import 'dart:async';

import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/advertisements/constants/advertisement_url.dart';

class MyAdsFetcher {
  final API _api;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;
  bool didReachEnd = false;
  int _currentPage = 1;

  MyAdsFetcher() : _api = API();

  Future<List<JobAdvertisement>> getNextMyAds() async {
    var url = AdvertisementUrls.myAds(_currentPage);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);

    _isLoading = true;
    try {
      var apiResponse = await _api.get(apiRequest);
      _isLoading = false;
      return _processResponse(apiResponse);
    } on APIException {
      _isLoading = false;
      rethrow;
    }
  }

  Future<List<JobAdvertisement>> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<JobAdvertisement>>().future;
    if (apiResponse.data == null) throw UnknownException();
    if (apiResponse.data['Result'] == null) throw UnknownException();
    if (apiResponse.data['Result']['data'] == null) throw UnknownException();

    var responseList = apiResponse.data['Result']['data'] as List;

    var myAds = <JobAdvertisement>[];
    try {
      for (var element in responseList) {
        myAds.add(JobAdvertisement.fromJson(element));
      }
      _updatePaginationData(myAds.length);
      return myAds;
    } catch (e) {
      throw UnknownException();
    }
  }

  bool get isLoading => _isLoading;

  void _updatePaginationData(int length) {
    if (length == 0) {
      didReachEnd = true;
    } else {
      _currentPage += 1;
    }
  }

  void refreshPagination() {
    didReachEnd = false;
    _currentPage = 1;
  }
}
