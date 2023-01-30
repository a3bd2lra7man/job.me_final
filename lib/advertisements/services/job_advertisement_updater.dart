import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/advertisements/constants/advertisement_url.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';

class JobAdvertisementUpdater {
  final API _networkAdapter = API();
  bool isLoading = false;

  JobAdvertisementUpdater();

  Future updateAnAdJob(JobAdvertisement jobAdvertisement) async {
    isLoading = true;
    var url = AdvertisementUrls.updateAnAdJobUrl(jobAdvertisement.id);
    var apiRequest = APIRequest(url);
    var body = jobAdvertisement.toJson();
    apiRequest.addParameters(body);
    try {
      var apiResponse = await _networkAdapter.put(apiRequest);
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
