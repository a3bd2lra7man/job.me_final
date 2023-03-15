import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/advertisement_core/constants/advertisements_core_urls.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';

class JobAdvertisementDeleter {
  final API _networkAdapter = API();
  bool isLoading = false;

  JobAdvertisementDeleter();

  Future deleteAnAdJob(JobAdvertisement jobAdvertisement) async {
    isLoading = true;
    var url = AdvertisementCoreUrls.deleteAnAdJobUrl(jobAdvertisement.id);
    var apiRequest = APIRequest(url);
    try {
      var apiResponse = await _networkAdapter.delete(apiRequest);
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
