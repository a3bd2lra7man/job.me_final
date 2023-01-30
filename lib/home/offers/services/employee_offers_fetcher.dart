import 'dart:async';

import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/home/offers/constants/offers_urls.dart';
import 'package:job_me/home/offers/models/employee_offer.dart';


class EmployeeOffersFetcher {
  final API _api;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;
  bool didReachEnd = false;
  int _currentPage = 1;

  EmployeeOffersFetcher() : _api = API();

  Future<List<EmployeeOffer>> getNextOffers() async {
    var url = OfferUrls.employeeOffersUrls(_currentPage);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);

    _isLoading = true;
    try {
      var apiResponse = await _api.get(apiRequest);
      _isLoading = false;
      return _processResponse(apiResponse);
    } on APIException  {
      _isLoading = false;
      rethrow;
    }
  }

  Future<List<EmployeeOffer>> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<EmployeeOffer>>().future;
    if (apiResponse.data == null) throw UnknownException();
    if (apiResponse.data['Result'] == null) throw UnknownException();
    if (apiResponse.data['Result']['ads'] == null) throw UnknownException();
    if (apiResponse.data['Result']['ads']['data'] == null) throw UnknownException();

    var responseList = apiResponse.data['Result']['ads']['data'] as List;

    var offers = <EmployeeOffer>[];
    try {
      for (var element in responseList) {
        offers.add(EmployeeOffer.fromJson(element));
      }
      _updatePaginationData(offers.length);
      return offers;
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
}
