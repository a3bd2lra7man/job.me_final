import 'dart:async';

import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/company_profile/company_department/constants/company_department_urls.dart';
import 'package:job_me/company_profile/company_department/models/company_department.dart';

class CompanyDepartmentUpdater {
  final API _api;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  CompanyDepartmentUpdater() : _api = API();

  Future updateCompanyDepartment(CompanyDepartment companyDepartment) async {
    var url = CompanyDepartmentsUrls.updateCompanyDepartmentUrls(companyDepartment.id!);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameters(companyDepartment.toJson());
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
