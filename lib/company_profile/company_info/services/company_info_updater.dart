import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:http/http.dart' as http;
import 'package:job_me/company_profile/company_info/constants/company_info_urls.dart';
import 'package:job_me/company_profile/company_info/models/company_info_form_data.dart';

class CompanyInfoUpdater {
  final API _networkAdapter = API();
  bool isLoading = false;

  CompanyInfoUpdater();

  Future update(CompanyInfoFormData companyInfoFormData) async {
    isLoading = true;
    var url = CompanyInfoUrls.updateCompanyInfoUrls();
    var apiRequest = APIRequest(url);
    var map = companyInfoFormData.toJson();

    if (companyInfoFormData.photoFile != null) {
      var photo = companyInfoFormData.photoFile!;
      var photoToUpload = await http.MultipartFile.fromPath('photo', photo.name, filename: photo.name);
      map['photo'] = photoToUpload;
    }
    apiRequest.addParameters(map);
    try {
      var apiResponse = await _networkAdapter.postWithFormData(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on APIException {
      isLoading = false;
      rethrow;
    }
  }

  Future _processResponse(APIResponse apiResponse) async {
    if (apiResponse.data['Status'] == null || apiResponse.data['Status'] == false) {
      throw UnknownException();
    }
  }
}
