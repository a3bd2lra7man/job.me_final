import 'package:job_me/buy_coins/models/buy_coins_offer.dart';

class BuyCoinsModel {
  List<BuyCoinsOffer> offers = [];
  num balance;

  BuyCoinsModel({required this.offers, required this.balance});
}
