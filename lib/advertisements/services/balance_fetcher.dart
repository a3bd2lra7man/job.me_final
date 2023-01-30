import 'dart:async';

import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/advertisements/constants/advertisement_url.dart';

class BalanceFetcher {
  final API _api;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  BalanceFetcher() : _api = API();

  Future<num> getAdvertisementsOffers() async {
    var url = AdvertisementUrls.offersUrl();
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

  Future<num> _processResponse(APIResponse apiResponse) async {
    _throwExceptionIfResponseFormatIsWrong(apiResponse);

    try {
      var balance = _getBalance(apiResponse);
      return balance;
    } catch (e) {
      throw UnknownException();
    }
  }

  bool get isLoading => _isLoading;

  void _throwExceptionIfResponseFormatIsWrong(APIResponse apiResponse) {
    if (apiResponse.data == null) throw UnknownException();
    if (apiResponse.data['Result'] == null) throw UnknownException();
    if (apiResponse.data['Result']['balance'] == null) throw UnknownException();
  }

  num _getBalance(APIResponse apiResponse) {
    return apiResponse.data['Result']['balance'] as num;
  }
}
