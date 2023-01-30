import 'package:job_me/_shared/api/constants/base_url.dart';

class BuyCoinsUrls{

  static paymentGatewayUrlGeneratorUrl() {
    return "${BaseUrls.baseUrl()}/myfatorah";
  }

  static paymentStatusUrl(String paymentId) {
    return "${BaseUrls.baseUrl()}/statusPayment?paymentId=$paymentId";
  }
}