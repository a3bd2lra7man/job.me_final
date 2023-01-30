import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/home/job_details/constants/job_details_urls.dart';

class JobCanceler {
  final API _networkAdapter = API();
  bool isLoading = false;

  JobCanceler();

  Future cancelJob(int jobId) async {
    isLoading = true;
    var url = JobDetailsUrls.cancelJob();
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

  Future _processResponse(APIResponse apiResponse) async {
    if (apiResponse.data['Result'] == null || apiResponse.data['Result'] == false) {
      throw UnknownException();
    }
  }
}
