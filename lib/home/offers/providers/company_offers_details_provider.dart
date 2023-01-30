import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/home/_shared/models/company_offer_details.dart';
import 'package:job_me/home/_shared/services/comapny_offers_details_fetcher.dart';
import 'package:job_me/home/offers/services/employee_resume_with_application_status_fetcher.dart';
import 'package:job_me/home/offers/services/offer_accepter.dart';
import 'package:job_me/home/offers/services/offer_canceler.dart';

class CompanyOffersDetailsProvider extends ChangeNotifier {
  BuildContext context;

  CompanyOffersDetailsProvider(this.context);

  final CompanyOffersDetailsFetcher _offersDetailsFetcher = CompanyOffersDetailsFetcher();
  final EmployeeResumeWithApplicationStatusFetcher _resumeWithApplicationStatusFetcher =
      EmployeeResumeWithApplicationStatusFetcher();
  final OfferAcceptor _offerAcceptor = OfferAcceptor();
  final OfferCanceler _offerCanceler = OfferCanceler();
  CompanyOfferDetails? offer;

  bool _isLoading = false;
  bool _isTransactionLoading = false;

  bool get isLoading => _isLoading;

  bool get isTransactionLoading => _isTransactionLoading;

  Future getOfferDetails(int offerId) async {
    _isLoading = true;
    notifyListeners();
    try {
      offer = await _offersDetailsFetcher.getOfferDetails(offerId);
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    _isLoading = false;
    notifyListeners();
  }

  Future getEmployeeResumeWithApplicationStatus(int employeeId, int jobId) async {
    _isLoading = true;
    notifyListeners();
    try {
      var resume = await _resumeWithApplicationStatusFetcher.getResume(employeeId, jobId);
      _isLoading = false;
      notifyListeners();
      return resume;
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    _isLoading = false;
    notifyListeners();
  }

  Future acceptOffer(int jobId,int employeeId) async {
    _isTransactionLoading = true;
    notifyListeners();

    try {
      await _offerAcceptor.acceptOffer(jobId,employeeId);
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    _isTransactionLoading = false;
    notifyListeners();
  }

  Future cancelOffer(int jobId,int employeeId) async {
    _isTransactionLoading = true;
    notifyListeners();

    try {
      await _offerCanceler.cancelOffer(jobId, employeeId);
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    _isTransactionLoading = false;
    notifyListeners();
  }
}
