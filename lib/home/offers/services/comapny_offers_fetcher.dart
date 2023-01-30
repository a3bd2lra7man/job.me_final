import 'dart:async';

import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/home/offers/constants/offers_urls.dart';
import 'package:job_me/home/offers/models/company_offer.dart';


class CompanyOffersFetcher {
  final API _api;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;
  bool didReachEnd = false;
  int _currentPage = 1;

  CompanyOffersFetcher() : _api = API();

  Future<List<CompanyOffer>> getNextOffers() async {
    var url = OfferUrls.companyOffersUrls(_currentPage);
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

  Future<List<CompanyOffer>> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<CompanyOffer>>().future;
    if (apiResponse.data == null) throw UnknownException();
    if (apiResponse.data['Result'] == null) throw UnknownException();
    if (apiResponse.data['Result']['data'] == null) throw UnknownException();

    var responseList = apiResponse.data['Result']['data'] as List;

    var offers = <CompanyOffer>[];
    try {
      for (var element in responseList) {
        offers.add(CompanyOffer.fromJson(element));
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
