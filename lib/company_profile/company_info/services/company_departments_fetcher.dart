import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/company_profile/company_info/constants/company_info_urls.dart';
import 'package:job_me/company_profile/company_info/models/company_info.dart';

class CompanyInfoFetcher {
  final API _networkAdapter = API();
  bool isLoading = false;

  CompanyInfoFetcher();

  Future<CompanyInfo> fetch() async {
    isLoading = true;
    var url = CompanyInfoUrls.fetchCompanyInfoUrl();
    var apiRequest = APIRequest(url);

    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on APIException {
      isLoading = false;
      rethrow;
    }
  }

  Future<CompanyInfo> _processResponse(APIResponse apiResponse) async {
    if (apiResponse.data['Result'] == null) {
      throw UnknownException();
    }
    try {
      var responseMap = apiResponse.data['Result'] as Map;
      return CompanyInfo.fromJson(responseMap);
    } catch (e) {
      throw UnknownException();
    }
  }
}
