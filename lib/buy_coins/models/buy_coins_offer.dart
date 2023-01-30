class BuyCoinsOffer{
  late int id;
  late String name;
  late String description;
  late String period;
  late String price;

  BuyCoinsOffer.fromJson(Map json){
    id = json['id'];
    name = json['name'];
    description = json['description'];
    period = json['period'];
    price = json['price'];
  }
}