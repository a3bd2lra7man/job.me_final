import 'dart:async';

import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/home/job_details/constants/job_details_urls.dart';
import 'package:job_me/home/job_details/models/job_ads_details.dart';

class JobDetailsFetcher {
  final API _api;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  JobDetailsFetcher() : _api = API();

  Future<JobAdsDetails> getJobDetails(int jobId) async {
    var url = JobDetailsUrls.jobUrls(jobId);
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

  Future<JobAdsDetails> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<JobAdsDetails>().future;
    if (apiResponse.data == null) throw UnknownException();
    if (apiResponse.data['Result'] == null) throw UnknownException();

    var responseMap = apiResponse.data['Result'] as Map;

    try {
      var job = JobAdsDetails.fromJson(responseMap);
      return job;
    } catch (e) {
      throw UnknownException();
    }
  }

  bool get isLoading => _isLoading;
}
