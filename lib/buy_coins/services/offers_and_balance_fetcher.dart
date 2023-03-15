import 'dart:async';

import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/advertisements/constants/advertisement_url.dart';
import 'package:job_me/buy_coins/models/buy_coins_model.dart';
import 'package:job_me/buy_coins/models/buy_coins_offer.dart';

class OffersAndBalanceFetcher {
  final API _api;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  OffersAndBalanceFetcher() : _api = API();

  Future<BuyCoinsModel> getCoinsOffersWithBalance() async {
    var url = AdvertisementUrls.balanceUrl();
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

  Future<BuyCoinsModel> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<BuyCoinsModel>().future;
    _throwExceptionIfResponseFormatIsWrong(apiResponse);

    try {
      var offers = _getAdvertisementsOffers(apiResponse);
      var balance = _getBalance(apiResponse);
      return BuyCoinsModel(offers: offers, balance: balance);
    } catch (e) {
      throw UnknownException();
    }
  }

  bool get isLoading => _isLoading;

  void _throwExceptionIfResponseFormatIsWrong(APIResponse apiResponse) {
    if (apiResponse.data == null) throw UnknownException();
    if (apiResponse.data['Result'] == null) throw UnknownException();
    if (apiResponse.data['Result']['plans'] == null) throw UnknownException();
    if (apiResponse.data['Result']['orders'] == null) throw UnknownException();
    if (apiResponse.data['Result']['orders']['data'] == null) throw UnknownException();
    if (apiResponse.data['Result']['balance'] == null) throw UnknownException();
  }

  List<BuyCoinsOffer> _getAdvertisementsOffers(APIResponse apiResponse) {
    var offersList = apiResponse.data['Result']['plans'] as List;
    var offers = <BuyCoinsOffer>[];
    for (var element in offersList) {
      offers.add(BuyCoinsOffer.fromJson(element));
    }
    return offers;
  }


  num _getBalance(APIResponse apiResponse) {
    return apiResponse.data['Result']['balance'] as num;
  }
}
