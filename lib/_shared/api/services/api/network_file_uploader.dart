// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:job_me/_shared/api/entities/image_file.dart';

import '../../entities/api_request.dart';
import '../../entities/api_response.dart';
import '../../exceptions/api_exception.dart';
import '../../exceptions/unexpected_response_format_exception.dart';

class NetworkFileUploader {
  Future<APIResponse> upload(List<ImageFile> files, APIRequest apiRequest, {Function(double)? onUploadProgress}) async {
    if (await _isConnected() == false) throw NetworkFailureException();

    final url = apiRequest.url;
    final request = MultipartRequest(
      'POST',
      Uri.parse(url),
      onProgress: (int bytes, int total) {
        var progress = (bytes / total) * 100;
        print("----------------------------------");
        print("File upload progress - $progress");
        print("----------------------------------");
        if (onUploadProgress != null) onUploadProgress(progress);
      },
    );
    print(1);
    request.headers.addAll(apiRequest.headers);
    print(2);

    for (ImageFile file in files) {
      request.files.add(
        http.MultipartFile.fromBytes(file.name, file.bytes),
      );
    }

    try {
      print(3);
      final response = await request.send();
      print(4);
      return _processResponse(response, apiRequest);
    } catch (error) {
      print("----------------------------------");
      print("File upload failed - ${error.toString()}");
      print("----------------------------------");
      throw ServerSentException(errorResponse: error.toString());
    }
  }

  Future<bool> _isConnected() async {
    return InternetConnectionCheckerPlus().hasConnection;
  }


  Future<APIResponse> _processResponse(http.StreamedResponse response, APIRequest apiRequest) async {
    var responseString = await response.stream.bytesToString();
    if (response.statusCode != 200) throw HTTPException();
    try {
      var responseData = json.decode(responseString);
      print(responseData);
      print("----------------------------------");
      print("File upload complete - ${apiRequest.url}");
      print("Response - $responseData");
      print("----------------------------------");
      return APIResponse(apiRequest, 200, responseData, {});
    } catch (error) {
      print("----------------------------------");
      print("File upload failed - ${error.toString()}");
      print("----------------------------------");
      throw UnexpectedResponseFormatException();
    }
  }
}

class MultipartRequest extends http.MultipartRequest {
  MultipartRequest(String method, Uri url, {this.onProgress}) : super(method, url);

  final void Function(int bytes, int totalBytes)? onProgress;

  /// Freezes all mutable fields and returns a single-subscription [ByteStream]
  /// that will emit the request body.
  @override
  http.ByteStream finalize() {
    final byteStream = super.finalize();
    if (onProgress == null) return byteStream;

    final total = contentLength;
    int bytes = 0;

    final t = StreamTransformer.fromHandlers(
      handleData: (List<int> data, EventSink<List<int>> sink) {
        bytes += data.length;
        if (onProgress != null) onProgress!(bytes, total);
        sink.add(data);
      },
    );
    final stream = byteStream.transform(t);
    return http.ByteStream(stream);
  }
}
