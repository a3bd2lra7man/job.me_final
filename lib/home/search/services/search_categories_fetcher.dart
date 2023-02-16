import 'dart:async';

import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/home/search/constants/search_jobs_urls.dart';
import 'package:job_me/home/search/models/category.dart';

class SearchCategoriesFetcher {
  final API _api;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  SearchCategoriesFetcher() : _api = API();

  Future<List<Category>> getCategories() async {
    var categoriesUrl = SearchUrls.categoriesUrl();
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var categoriesApiRequest = APIRequest.withId(categoriesUrl, _sessionId);

    _isLoading = true;
    try {
      var categoriesApiResponse = await _api.get(categoriesApiRequest);
      _isLoading = false;
      return _processResponse(categoriesApiResponse, );
    } on APIException {
      _isLoading = false;
      rethrow;
    }
  }

  Future<List<Category>> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<Category>>().future;

    _throwExceptionIfResponseHasWrongFormat(apiResponse);

    var categoriesList = apiResponse.data['Result']['data'] as List;
    var resultCategories = <Category>[];
    try {
      for (var element in categoriesList) {
        resultCategories.add(Category.fromJson(element));
      }
      return resultCategories;
    } catch (e) {
      throw UnknownException();
    }
  }

  bool get isLoading => _isLoading;


  void _throwExceptionIfResponseHasWrongFormat(APIResponse normalApiResponse) {
    if (normalApiResponse.data == null) throw UnknownException();
    if (normalApiResponse.data['Result'] == null) throw UnknownException();
    if (normalApiResponse.data['Result']['data'] == null) throw UnknownException();
  }
}
