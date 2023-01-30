import 'dart:async';

import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/home/search/constants/search_jobs_urls.dart';

class SearchJobsResultFetcher {
  final API _api;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;
  bool didReachEnd = false;
  int _currentPage = 1;

  SearchJobsResultFetcher() : _api = API();

  Future<List<JobAdvertisement>> getNext(String searchText) async {
    var normalJobUrl = SearchUrls.searchNormalJobUrl(_currentPage, searchText);
    var specialJobUrl = SearchUrls.searchSpecialJobUrl(_currentPage, searchText);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var normalJobSearchApiRequest = APIRequest.withId(normalJobUrl, _sessionId);
    var specialJobSearchApiRequest = APIRequest.withId(specialJobUrl, _sessionId);

    _isLoading = true;
    try {
      var normalJobApiResponse = await _api.get(normalJobSearchApiRequest);
      var specialJobApiResponse = await _api.get(specialJobSearchApiRequest);
      _isLoading = false;
      return _processResponse(normalJobApiResponse, specialJobApiResponse);
    } on APIException {
      _isLoading = false;
      rethrow;
    }
  }

  Future<List<JobAdvertisement>> _processResponse(APIResponse normalApiResponse, APIResponse specialApiResponse) async {
    //returning empty list if the response is from another session
    if (normalApiResponse.apiRequest.requestId != _sessionId) return Completer<List<JobAdvertisement>>().future;
    if (specialApiResponse.apiRequest.requestId != _sessionId) return Completer<List<JobAdvertisement>>().future;

    _throwExceptionIfResponseHasWrngFormat(normalApiResponse, specialApiResponse);

    var normalResponseList = normalApiResponse.data['Result']['data'] as List;
    var specialResponseList = specialApiResponse.data['Result']['data'] as List;
    var resultJobs = <JobAdvertisement>[];
    try {
      for (var element in normalResponseList) {
        resultJobs.add(JobAdvertisement.fromJson(element));
      }
      for (var element in specialResponseList) {
        resultJobs.add(JobAdvertisement.fromJson(element));
      }
      _updatePaginationData(resultJobs.length);
      return resultJobs;
    } catch (e) {
      throw UnknownException();
    }
  }

  bool get isLoading => _isLoading;

  void resetPaginationData() {
    _currentPage = 1;
    didReachEnd = false;
  }

  void _updatePaginationData(int length) {
    if (length == 0) {
      didReachEnd = true;
    } else {
      _currentPage += 1;
    }
  }

  void _throwExceptionIfResponseHasWrngFormat(APIResponse normalApiResponse, APIResponse specialApiResponse) {
    if (normalApiResponse.data == null) throw UnknownException();
    if (normalApiResponse.data['Result'] == null) throw UnknownException();
    if (normalApiResponse.data['Result']['data'] == null) throw UnknownException();

    if (specialApiResponse.data == null) throw UnknownException();
    if (specialApiResponse.data['Result'] == null) throw UnknownException();
    if (specialApiResponse.data['Result']['data'] == null) throw UnknownException();
  }
}
