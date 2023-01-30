import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/advertisements/constants/advertisement_url.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/advertisements/exceptions/account_is_not_activated.dart';

class JobAdvertisementAdder {
  final API _networkAdapter = API();
  bool isLoading = false;

  JobAdvertisementAdder();

  Future advertiseAJob(JobAdvertisement jobAdvertisement) async {
    isLoading = true;
    var url = AdvertisementUrls.advertiseAJobUrl();
    var apiRequest = APIRequest(url);
    apiRequest.addParameters(jobAdvertisement.toJson());
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
    if ((apiResponse.data['Status'] == null && apiResponse.data['status'] == null) || (apiResponse.data['Status']  == false && apiResponse.data['status'] != 0) ) {
      throw UnknownException();
    }
    if(apiResponse.data['status'] == 0) throw AccountIsNotActivated();
  }
}
