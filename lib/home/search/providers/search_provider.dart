import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/home/search/models/category.dart';
import 'package:job_me/home/search/services/search_categories_fetcher.dart';
import 'package:job_me/home/search/services/search_countries_fetcher.dart';
import 'package:job_me/home/search/services/search_jobs_result_fetcher.dart';

class SearchJobsProvider extends ChangeNotifier {
  BuildContext context;

  SearchJobsProvider(this.context);

  final searchController = TextEditingController();
  Category? selectedCategory;
  String? selectedCountry;
  List<Category> selectableCategories = [];
  List<String> selectableCountries = [];

  final SearchJobsResultFetcher _searchJobsResultFetcher = SearchJobsResultFetcher();
  final SearchCountriesFetcher _countriesFetcher = SearchCountriesFetcher();
  final SearchCategoriesFetcher _categoriesFetcher = SearchCategoriesFetcher();
  final List<JobAdvertisement> resultJobs = [];
  bool _isFirstLoading = false;
  bool _isPaginationLoading = false;

  bool get isFirstLoading => _isFirstLoading;

  bool get isPaginationLoading => _isPaginationLoading;

  Future getCountriesAndCategories() async {
    _notify(loading: true, firstTime: true);

    try {
      selectableCategories = await _categoriesFetcher.getCategories();
      selectableCountries = await _countriesFetcher.getCountries();
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    _notify(loading: false, firstTime: true);
  }

  void setSelectedCategory(Category? category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setSelectedCountry(String? country) {
    selectedCountry = country;
    notifyListeners();
  }

  Future searchedJobs() async {
    resultJobs.clear();
    _notify(loading: true, firstTime: true);

    try {
      _searchJobsResultFetcher.resetPaginationData();
      var result =
          await _searchJobsResultFetcher.getNext(searchController.text, selectedCategory?.id, selectedCountry);
      if (_searchJobsResultFetcher.didReachEnd) _toastThatListReachEnd();
      resultJobs.addAll(result);
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    _notify(loading: false, firstTime: true);
  }

  Future getNextSearchedJobs() async {
    if (_checkIfPaginationReachEnd()) return;
    var isFirstLoading = _getIfThisPaginationLoadingOrTheFirstTime();
    _notify(loading: true, firstTime: isFirstLoading);

    try {
      var result =
          await _searchJobsResultFetcher.getNext(searchController.text, selectedCategory?.id, selectedCountry);
      if (_searchJobsResultFetcher.didReachEnd) _toastThatListReachEnd();
      resultJobs.addAll(result);
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    _notify(loading: false, firstTime: isFirstLoading);
  }

  bool _checkIfPaginationReachEnd() {
    if (_searchJobsResultFetcher.didReachEnd) {
      _toastThatListReachEnd();
      return true;
    }
    return false;
  }

  bool _getIfThisPaginationLoadingOrTheFirstTime() {
    bool isFirstTime = resultJobs.isEmpty;
    return isFirstTime;
  }

  _notify({required bool loading, required bool firstTime}) {
    if (firstTime) {
      _isFirstLoading = loading;
    } else {
      _isPaginationLoading = loading;
    }
    notifyListeners();
  }

  _toastThatListReachEnd() {
    showSnackBar(body: context.translate('no_more_data'));
  }
}
