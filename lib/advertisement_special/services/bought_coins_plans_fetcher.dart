import 'dart:async';

import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/advertisement_core/models/bought_coins_plan.dart';
import 'package:job_me/advertisement_special/constants/advertisement_special_url.dart';

class TransactionsFetcher {
  final API _api;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  TransactionsFetcher() : _api = API();

  Future<List<BoughtCoinsPlan>> getBoughtCoinsPlans() async {
    var url = AdvertisementsSpecialUrls.boughtCoinsUrl();
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

  Future<List<BoughtCoinsPlan>> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<BoughtCoinsPlan>>().future;
    _throwExceptionIfResponseFormatIsWrong(apiResponse);

    try {
      return _getUsersTransactions(apiResponse);
    } catch (e) {
      throw UnknownException();
    }
  }

  bool get isLoading => _isLoading;

  void _throwExceptionIfResponseFormatIsWrong(APIResponse apiResponse) {
    if (apiResponse.data == null) throw UnknownException();
    if (apiResponse.data['Result'] == null) throw UnknownException();
    if (apiResponse.data['Result']['orders'] == null) throw UnknownException();
    if (apiResponse.data['Result']['orders']['data'] == null) throw UnknownException();
    if (apiResponse.data['Result']['plans'] == null) throw UnknownException();
  }

  List<BoughtCoinsPlan> _getUsersTransactions(APIResponse apiResponse) {
    var plans = apiResponse.data['Result']['plans'] as List;
    var transactionsList = apiResponse.data['Result']['orders']['data'] as List;
    var transactions = <BoughtCoinsPlan>[];
    for (var element in transactionsList) {
      transactions.add(BoughtCoinsPlan.fromJson(element,plans));
    }
    return transactions;
  }
}
