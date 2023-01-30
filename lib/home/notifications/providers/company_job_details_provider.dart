import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/home/_shared/models/company_offer_details.dart';
import 'package:job_me/home/_shared/services/comapny_offers_details_fetcher.dart';

class CompanyJobDetailsProvider extends ChangeNotifier {
  BuildContext context;

  final CompanyOffersDetailsFetcher _companyOffersDetailsFetcher = CompanyOffersDetailsFetcher();
  CompanyOfferDetails? companyOfferDetails;

  CompanyJobDetailsProvider(this.context);

  bool isLoading = false;

  Future getJobDetails(int jobId) async {
    isLoading = true;
    notifyListeners();
    try {
      companyOfferDetails = await _companyOffersDetailsFetcher.getOfferDetails(jobId);
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    isLoading = false;
    notifyListeners();
  }
}
