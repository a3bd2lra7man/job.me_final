import 'dart:io';


import '../../entities/api_request.dart';
import '../../exceptions/server_sent_exception.dart';
import 'network_file_downloader.dart';

class ApiFileDownloader {
  late NetworkFileDownloader _networkFileDownloader;

  ApiFileDownloader() {
    _networkFileDownloader = NetworkFileDownloader();
  }

  Future<File> download(String url, {Function(double)? onDownloadProgress}) async {
    if (url.isEmpty) throw ServerSentException(errorResponse: 'file url is empty');

    APIRequest apiRequest = APIRequest(url);
    return await _networkFileDownloader.downloadFile(
      apiRequest,
      onDownloadProgress: onDownloadProgress,
    );
  }
}
