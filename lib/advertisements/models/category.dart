class Category {
  late int id;

  late String _nameAr;
  late String _nameEn;


  Category.fromJson(Map json) {
    id = json['id'];
    _nameAr = json['name_ar'];
    _nameEn = json['name_en'];
  }


  String getName(bool isEn){
    return isEn ? _nameEn : _nameAr;
  }
}