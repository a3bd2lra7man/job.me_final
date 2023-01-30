import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/home/offers/constants/offers_urls.dart';

class OfferAcceptor {
  final API _networkAdapter = API();
  bool isLoading = false;

  OfferAcceptor();

  Future<bool> acceptOffer(int jobId, int employeeId) async {
    isLoading = true;
    var url = OfferUrls.acceptOffer();
    var apiRequest = APIRequest(url);
    apiRequest.addParameters({"adsId": jobId,"user_id":employeeId});
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
    if (apiResponse.data['Status'] == null || apiResponse.data['Status']  == false) {
      throw UnknownException();
    }
    return true;
  }
}
