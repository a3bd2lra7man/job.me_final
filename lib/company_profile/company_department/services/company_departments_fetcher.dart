import 'dart:async';

import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/company_profile/company_department/constants/company_department_urls.dart';
import 'package:job_me/company_profile/company_department/models/company_department.dart';

class JobDetailsFetcher {
  final API _api;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  JobDetailsFetcher() : _api = API();

  Future<List<CompanyDepartment>> getCompanyDepartments() async {
    var url = CompanyDepartmentsUrls.fetchCompanyDepartmentUrl();
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

  Future<List<CompanyDepartment>> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<CompanyDepartment>>().future;
    if (apiResponse.data == null) throw UnknownException();
    if (apiResponse.data['Result'] == null) throw UnknownException();

    var responseList = apiResponse.data['Result']['data'] as List;

    var departments = <CompanyDepartment>[];
    try {
      for (var element in responseList) {
        departments.add(CompanyDepartment.fromJson(element));
      }
      return departments;
    } catch (e) {
      throw UnknownException();
    }
  }

  bool get isLoading => _isLoading;
}
