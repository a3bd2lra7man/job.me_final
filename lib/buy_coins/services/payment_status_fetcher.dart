import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/buy_coins/constants/buy_coins_url.dart';

class PaymentStatusFetcher {
  final API _networkAdapter = API();
  bool isLoading = false;

  PaymentStatusFetcher();

  Future<bool> isPaymentSuccess(String paymentId) async {
    isLoading = true;
    var url = BuyCoinsUrls.paymentStatusUrl(paymentId);
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

  Future<bool> _processResponse(APIResponse apiResponse) async {
    if (apiResponse.data['Status'] == null || apiResponse.data['Status'] == false) {
      return false;
    }
    return true;
  }
}
