import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/advertisements/constants/advertisement_url.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/advertisements/models/transactions.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';

class AdToSpecialAdder {
  final API _networkAdapter = API();
  bool isLoading = false;

  AdToSpecialAdder();

  Future addToSpecial(JobAdvertisement jobAdvertisement, Transaction transaction) async {
    isLoading = true;
    var url = AdvertisementUrls.addToSpecial();
    var apiRequest = APIRequest(url);
    var userId = UserRepository().getUser().id;
    apiRequest.addParameters({'ads_id': jobAdvertisement.id, "order_id": transaction.id,"user_id":userId});
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
    if (apiResponse.data['Status'] == null || apiResponse.data['Status'] == false) {
      throw UnknownException();
    }
  }
}
