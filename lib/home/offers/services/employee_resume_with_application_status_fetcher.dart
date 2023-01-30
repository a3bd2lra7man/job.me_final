import 'dart:async';

import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/home/offers/constants/offers_urls.dart';
import 'package:job_me/home/offers/models/employee_resume_with_application_status_model.dart';

class EmployeeResumeWithApplicationStatusFetcher {
  final API _api;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  EmployeeResumeWithApplicationStatusFetcher() : _api = API();

  Future<EmployeeResumeWithApplyStatusModel> getResume(int employeeId, int jobToApply) async {
    var url = OfferUrls.fetchEmployeeResumeWithApplicationStatus(employeeId, jobToApply);
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

  Future<EmployeeResumeWithApplyStatusModel> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<EmployeeResumeWithApplyStatusModel>().future;
    if (apiResponse.data == null) throw UnknownException();
    if (apiResponse.data['Result'] == null) throw UnknownException();

    var responseMap = apiResponse.data['Result'] as Map;

    try {
      var resume = EmployeeResumeWithApplyStatusModel.fromJson(responseMap);
      return resume;
    } catch (e) {
      throw UnknownException();
    }
  }

  bool get isLoading => _isLoading;
}
