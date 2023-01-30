import 'package:job_me/user/_user_core/repositories/user_repository.dart';

import '../../entities/api_request.dart';
import '../../entities/api_response.dart';
import '../../exceptions/api_exception.dart';
import 'network_adapter.dart';
import 'network_request_executor.dart';


class API implements NetworkAdapter {
  late NetworkAdapter _networkAdapter;

  API() {
    _networkAdapter = NetworkRequestExecutor();
  }

  @override
  Future<APIResponse> get(APIRequest apiRequest, {bool forceRefresh = false}) async {
    apiRequest.addHeaders(await _buildRequestHeaders(forceRefresh: forceRefresh));
    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      return apiResponse;
    } on APIException catch (exception) {
      if (_shouldRefreshTokenOnException(exception)) {
        return get(apiRequest, forceRefresh: true);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<APIResponse> put(APIRequest apiRequest, {bool forceRefresh = false}) async {
    apiRequest.addHeaders(await _buildRequestHeaders(forceRefresh: forceRefresh));
    try {
      var apiResponse = await _networkAdapter.put(apiRequest);
      return apiResponse;
    } on APIException catch (exception) {
      if (_shouldRefreshTokenOnException(exception)) {
        return put(apiRequest, forceRefresh: true);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<APIResponse> post(APIRequest apiRequest, {bool forceRefresh = false}) async {
    apiRequest.addHeaders(await _buildRequestHeaders(forceRefresh: forceRefresh));
    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      return apiResponse;
    } on APIException catch (exception) {
      if (_shouldRefreshTokenOnException(exception)) {
        return post(apiRequest, forceRefresh: true);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<APIResponse> postWithFormData(APIRequest apiRequest, {bool forceRefresh = false}) async {
    apiRequest.addHeaders(await _buildRequestHeaders(forceRefresh: forceRefresh,isFormData: true));
    try {
      var apiResponse = await _networkAdapter.postWithFormData(apiRequest);
      return apiResponse;
    } on APIException catch (exception) {
      if (_shouldRefreshTokenOnException(exception)) {
        return post(apiRequest, forceRefresh: true);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<APIResponse> delete(APIRequest apiRequest, {bool forceRefresh = false}) async {
    apiRequest.addHeaders(await _buildRequestHeaders(forceRefresh: forceRefresh));
    try {
      var apiResponse = await _networkAdapter.delete(apiRequest);
      return apiResponse;
    } on APIException catch (exception) {
      if (_shouldRefreshTokenOnException(exception)) {
        return delete(apiRequest, forceRefresh: true);
      } else {
        rethrow;
      }
    }
  }

  Future<Map<String, String>> _buildRequestHeaders({
    bool forceRefresh = false,
    bool isFormData = false,

  }) async {
    var headers = <String, String>{};
    headers['Content-Type'] = isFormData ? 'multipart/form-data' : 'application/json';

    var authToken = UserRepository().getUserToken();
    if (authToken != null) {
      headers['Authorization'] = "Bearer $authToken";
    }
    return headers;
  }

  bool _shouldRefreshTokenOnException(APIException apiException) {
    if (apiException is ServerSentException) {
      try {
        var responseMap = apiException.responseData;
        var errorCode = responseMap['errorCode'];
        if (errorCode == 1022) return true;
      } catch (e) {
        //ignore exception as the response data is optional
      }
    }
    return false;
  }
}
