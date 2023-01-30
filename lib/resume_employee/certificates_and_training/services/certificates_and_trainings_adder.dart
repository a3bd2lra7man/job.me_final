import 'dart:async';

import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/resume_employee/certificates_and_training/constants/certificates_and_trainings_urls.dart';
import 'package:job_me/resume_employee/certificates_and_training/models/certificate_or_training.dart';

class CertificatesAndTrainingsAdder {
  final API _api;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  CertificatesAndTrainingsAdder() : _api = API();

  Future addCertificateOrTraining(CertificateOrTraining certificateOrTraining) async {
    var url = CertificatesAndTrainingsUrls.addCertificateUrls();
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameters(certificateOrTraining.toJson());
    _isLoading = true;
    try {
      var apiResponse = await _api.post(apiRequest);
      _isLoading = false;
      await _processResponse(apiResponse);
    } on APIException {
      _isLoading = false;
      rethrow;
    }
  }

  Future _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer().future;
    if (apiResponse.data == null) throw UnknownException();
    if (apiResponse.data['Status'] != true) throw UnknownException();
  }

  bool get isLoading => _isLoading;
}
