import 'package:job_me/_shared/api/constants/base_url.dart';

class GeneralAd{
  late String _imageUrl;
  late String urlToGo;

  String get image {
    if (_imageUrl.startsWith('http')) return _imageUrl;
    return "${BaseUrls.staticUrl()}/$_imageUrl";
  }

  GeneralAd.fromJson(Map map){
    _imageUrl = map['image'];
    urlToGo = map['link'];
  }
}