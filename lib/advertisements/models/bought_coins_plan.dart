class BoughtCoinsPlan {
  late int id;
  late String itemName;
  late int? adsJobsId;
  late int quantity;

  bool isUsed() => adsJobsId != null;

  BoughtCoinsPlan.fromJson(Map map) {
    id = map['id'];
    itemName = map['item_name'];
    adsJobsId = map['ads_jobs_id'];
    quantity = map['quantity'];
  }
}
