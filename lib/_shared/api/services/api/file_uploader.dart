import 'package:job_me/_shared/api/entities/image_file.dart';
import '../../constants/base_url.dart';
import '../../entities/api_request.dart';
import '../../entities/api_response.dart';
import '../../entities/file_upload_response.dart';
import '../../exceptions/missing_uploaded_file_names_exception.dart';
import '../../exceptions/server_sent_exception.dart';
import 'network_file_uploader.dart';

class FileUploader {
  late NetworkFileUploader _networkFileUploader;

  FileUploader() {
    _networkFileUploader = NetworkFileUploader();
  }

  Future<FileUploadResponse> upload(List<ImageFile> files, {Function(double)? onUploadProgress}) async {
    if (files.isEmpty) throw ServerSentException(errorResponse: 'no files attached');

    APIRequest apiRequest = APIRequest(BaseUrls.uploadUrl());
    apiRequest.addHeaders(await _buildRequestHeaders());
    var apiResponse = await _networkFileUploader.upload(files, apiRequest, onUploadProgress: onUploadProgress);
    return _processResponse(apiResponse, apiRequest);
  }

  Future<Map<String, String>> _buildRequestHeaders() async {
    var headers = <String, String>{};
    //TODO
    // if (authToken != null) {
    //   headers['Authorization'] = authToken;
    // }
    return headers;
  }

  FileUploadResponse _processResponse(APIResponse response, APIRequest apiRequest) {
    var responseData = response.data["response"];
    List<String> uploadedFileNames = [];
    if (responseData is Map<String, dynamic>) {
      for (dynamic value in responseData.values) {
        if (value is String) uploadedFileNames.add(value);
      }
    }

    if (uploadedFileNames.isEmpty) throw MissingUploadedFileNamesException();
    return FileUploadResponse(uploadedFileNames);
  }
}
