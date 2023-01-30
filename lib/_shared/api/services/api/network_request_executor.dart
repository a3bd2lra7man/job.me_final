// ignore_for_file: avoid_print
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../entities/api_request.dart';
import '../../entities/api_response.dart';
import '../../exceptions/api_exception.dart';
import '../../exceptions/unexpected_response_format_exception.dart';
import 'network_adapter.dart';

class NetworkRequestExecutor implements NetworkAdapter {
  Dio dio = Dio();

  NetworkRequestExecutor() {
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
  }

  @override
  Future<APIResponse> get(APIRequest apiRequest) async {
    return executeRequest(apiRequest, 'GET');
  }

  @override
  Future<APIResponse> post(APIRequest apiRequest) async {
    return executeRequest(apiRequest, 'POST');
  }

  @override
  Future<APIResponse> postWithFormData(APIRequest apiRequest) async {
    return executeRequestWithFormData(apiRequest);
  }

  @override
  Future<APIResponse> put(APIRequest apiRequest) async {
    return executeRequest(apiRequest, 'PUT');
  }

  @override
  Future<APIResponse> delete(APIRequest apiRequest) async {
    return executeRequest(apiRequest, 'DELETE');
  }

  Future<APIResponse> executeRequest(APIRequest apiRequest, String method) async {
    if (await _isConnected() == false) throw NetworkFailureException();
    try {
      Response<String> response = await dio.request(
        apiRequest.url,
        data: jsonEncode(apiRequest.parameters),
        options: Options(
          method: method,
          headers: apiRequest.headers,
          validateStatus: (status) => status != null && ((status >= 200 && status <= 210) || status == 403),
        ),
      );
      return _processResponse(response, apiRequest);
    } on DioError catch (error) {
      throw _processError(error);
    }
  }

  Future<APIResponse> executeRequestWithFormData(APIRequest apiRequest) async {
    try {
      var uri = Uri.parse(apiRequest.url);
      var request = http.MultipartRequest('POST', uri);
      apiRequest.parameters.forEach((key, value) {
        if (value.runtimeType == String) request.fields[key] = value;
        if (key == 'photo') request.files.add(value);
      });
      request.headers.addAll(apiRequest.headers);
      var response = await request.send();
      if (response.statusCode == 200) print('Uploaded!');
      String reply = await response.stream.transform(utf8.decoder).join();
      var res = json.decode(reply);
      print(res);
      return APIResponse(apiRequest, response.statusCode, res, {});
    } on DioError catch (error) {
      throw _processError(error);
    }
  }

  Future<bool> _isConnected() async {
    return InternetConnectionCheckerPlus().hasConnection;
  }

  APIResponse _processResponse(Response response, APIRequest apiRequest) {
    try {
      var responseData = json.decode(response.data);
      print(responseData);
      return APIResponse(apiRequest, response.statusCode!, responseData, {});
    } catch (e) {
      throw UnexpectedResponseFormatException();
    }
  }

  Exception _processError(DioError error) {
    try {
      if (error.response != null && error.response!.data != null) {
        var data = error.response!.data;
        var dataJson = json.decode(data);
        print(dataJson);
        return ServerSentException(errorResponse: dataJson);
      } else {
        return HTTPException();
      }
    } catch (e) {
      return HTTPException();
    }
  }
}
