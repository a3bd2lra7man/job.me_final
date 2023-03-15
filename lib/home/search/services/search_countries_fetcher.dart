import 'dart:async';

import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/home/search/constants/search_jobs_urls.dart';

class SearchCountriesFetcher {
  final API _api;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;
  bool didReachEnd = false;

  SearchCountriesFetcher() : _api = API();

  Future<List<String>> getCountries() async {
    var countriesUrl = SearchUrls.countriesUrl();
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var countryApiRequest = APIRequest.withId(countriesUrl, _sessionId);

    _isLoading = true;
    try {
      var countryApiResponse = await _api.get(countryApiRequest);
      _isLoading = false;
      return _processResponse(countryApiResponse);
    } on APIException {
      _isLoading = false;
      rethrow;
    }
  }

  Future<List<String>> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<String>>().future;

    _throwExceptionIfResponseHasWrongFormat(apiResponse);

    var countriesResponseList = apiResponse.data['Result']as List;
    var resultCountries = <String>[];
    try {
      for (var element in countriesResponseList) {
        resultCountries.add(element['country']);
      }
      return resultCountries;
    } catch (e) {
      throw UnknownException();
    }
  }


  void _throwExceptionIfResponseHasWrongFormat(APIResponse normalApiResponse) {
    if (normalApiResponse.data == null) throw UnknownException();
    if (normalApiResponse.data['Result'] == null) throw UnknownException();
  }
}
