import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/home/job_details/constants/job_details_urls.dart';
import 'package:job_me/home/job_details/exception/user_has_to_add_advertisement_first.dart';

class JobApplier {
  final API _networkAdapter = API();
  bool isLoading = false;

  JobApplier();

  Future<bool> applyForJob(int jobId) async {
    isLoading = true;
    var url = JobDetailsUrls.applyForJob();
    var apiRequest = APIRequest(url);
    apiRequest.addParameter("ads_id", jobId);
    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on APIException {
      isLoading = false;
      rethrow;
    }
  }

  Future<bool> pickEmployee(int jobId,int employeeId) async {
    isLoading = true;
    var url = JobDetailsUrls.pickEmployee();
    var apiRequest = APIRequest(url);
    apiRequest.addParameters({"adsId": jobId,'user_id':employeeId});
    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on APIException {
      isLoading = false;
      rethrow;
    }
  }

  Future<bool> _processResponse(APIResponse apiResponse) async {
    if ((apiResponse.data['Status'] == null && apiResponse.data['status'] == null) || (apiResponse.data['Status']  == false && apiResponse.data['status'] != 0) ) {
      throw UnknownException();
    }
    if(apiResponse.data['status'] == 0) throw UserHasToAddAdvertisementFirst();
    return true;
  }
}
