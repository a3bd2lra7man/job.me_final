import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/buy_coins/constants/buy_coins_url.dart';
import 'package:job_me/buy_coins/exception/user_has_to_add_advertisement_first.dart';
import 'package:job_me/buy_coins/models/buy_coins_offer.dart';

class PaymentGatewayUrlGenerator {
  final API _networkAdapter = API();
  bool isLoading = false;

  PaymentGatewayUrlGenerator();

  Future<String> generateLink(BuyCoinsOffer offer) async {
    isLoading = true;
    var url = BuyCoinsUrls.paymentGatewayUrlGeneratorUrl();
    var apiRequest = APIRequest(url);
    apiRequest.addParameters({'plan_id': offer.id, 'plan_count': 1});
    try {
      var apiResponse = await _networkAdapter.post(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on APIException {
      isLoading = false;
      rethrow;
    }
  }

  Future<String> _processResponse(APIResponse apiResponse) async {
    if ((apiResponse.data['Status'] == null && apiResponse.data['status'] == null) || (apiResponse.data['Status']  == false && apiResponse.data['status'] != 0) ) {
      throw UnknownException();
    }
    if(apiResponse.data['status'] == 0) throw UserHasToAddAdvertisementFirstThenBuyCoins();
    if (apiResponse.data['Result'] == null) throw UnknownException();
    if (apiResponse.data['Result']['invoiceURL'] == null) throw UnknownException();

    return apiResponse.data['Result']['invoiceURL'];
  }
}
