class BoughtCoinsPlan {
  late int id;
  late String itemName;
  late int? adsJobsId;
  late int quantity;
  late String description;

  bool isUsed() => adsJobsId != null;

  BoughtCoinsPlan.fromJson(Map map,List plansMap) {
    id = map['id'];
    itemName = map['item_name'];
    adsJobsId = map['ads_jobs_id'];
    quantity = map['quantity'];
    description = plansMap.firstWhere((element) => element['id'] == map['plan_id'])['description'];
  }
}
