import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/home/main/models/general_ad.dart';
import 'package:job_me/home/main/services/general_ads_fetcher.dart';

class GeneralAdsProvider extends ChangeNotifier {
  BuildContext context;

  GeneralAdsProvider(this.context);

  final GeneralAdsFetcher _adsFetcher = GeneralAdsFetcher();
  List<GeneralAd> generalAds = [];

  bool  isLoading = false;


  Future getAds() async {
    isLoading = true;
    notifyListeners();

    try {
      generalAds = await _adsFetcher.fetchGeneralAds();
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    isLoading = false;
    notifyListeners();
  }

}
