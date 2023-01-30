import 'dart:async';

import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/resume_employee/educations/constants/educations_urls.dart';
import 'package:job_me/resume_employee/educations/models/education.dart';

class EducationsUpdater {
  final API _api;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  EducationsUpdater() : _api = API();

  Future updateEducation(Education education) async {
    var url = EducationsUrls.updateEducationsUrl(education.id!);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameters(education.toJson());
    _isLoading = true;
    try {
      var apiResponse = await _api.put(apiRequest);
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
