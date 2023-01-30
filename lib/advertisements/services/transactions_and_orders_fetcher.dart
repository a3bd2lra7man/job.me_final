import 'dart:async';

import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/advertisements/constants/advertisement_url.dart';
import 'package:job_me/advertisements/models/transactions.dart';

class TransactionsFetcher {
  final API _api;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  TransactionsFetcher() : _api = API();

  Future<List<Transaction>> getTransactions() async {
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

  Future<List<Transaction>> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<Transaction>>().future;
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
  }

  List<Transaction> _getUsersTransactions(APIResponse apiResponse) {
    var transactionsList = apiResponse.data['Result']['orders']['data'] as List;
    var transactions = <Transaction>[];
    for (var element in transactionsList) {
      transactions.add(Transaction.fromJson(element));
    }
    return transactions;
  }
}
