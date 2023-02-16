// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/advertisements/services/categories_fetcher.dart';
import 'package:job_me/advertisements/services/job_advertisement_adder.dart';
import 'package:job_me/advertisements/services/job_advertisement_updater.dart';
import 'package:job_me/advertisements/ui/screens/failed_success/success_publish_a_job_advertisement.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/advertisements/ui/screens/my_advertisement_screen.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';

import '../models/category.dart';

class JobAdvertisementFormProvider extends ChangeNotifier {
  BuildContext context;
  List<Category> selectableCategories = [];

  JobAdvertisementFormProvider(this.context);

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final yearsOfExperienceController = TextEditingController();
  final hoursToWorkInPerDayController = TextEditingController();
  final requirementController = TextEditingController();
  Category? selectedCategory;

  bool isLoading = false;
  final jobAdvertiser = JobAdvertisementAdder();
  final jobAdUpdater = JobAdvertisementUpdater();

  void setSelectedCategory(Category? category) {
    selectedCategory = category;
    notifyListeners();
  }

  Future addJobAdvertisement() async {
    isLoading = true;
    notifyListeners();

    try {
      var jobAdvertisement = _getJobAdvertisement();
      await jobAdvertiser.advertiseAJob(jobAdvertisement);
      _clearControllers();
      Get.to(const SuccessfullyPublishedAJobAdvertisementScreen());
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    isLoading = false;
    notifyListeners();
  }

  Future updateJobAdvertisement(int id) async {
    isLoading = true;
    notifyListeners();

    try {
      var jobAdvertisement = _getJobAdvertisement();
      jobAdvertisement.id = id;
      await jobAdUpdater.updateAnAdJob(jobAdvertisement);
      showSnackBar(body: context.translate('updated_successfully'));
      _clearControllers();
      Get.off(MyAdvertisementScreen.init());
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    isLoading = false;
    notifyListeners();
  }

  JobAdvertisement _getJobAdvertisement() {
    return JobAdvertisement(
        title: titleController.text,
        description: descriptionController.text,
        yearsOfExperiences: num.parse(yearsOfExperienceController.text),
        workTime: num.parse(hoursToWorkInPerDayController.text),
        requirement: requirementController.text.isNotEmpty ? requirementController.text : null,
        categoryId: selectedCategory!.id);
  }

  void _clearControllers() {
    titleController.text = "";
    descriptionController.text = "";
    yearsOfExperienceController.text = "";
    hoursToWorkInPerDayController.text = "";
    requirementController.text = "";
  }

  // MARK: validators

  String? isJobNameValid(String? string) {
    return string != null && string.length >= 4 ? null : context.translate('enter_valid_string');
  }

  String? isLongTextValid(String? string) {
    return string != null && string.length >= 8
        ? null
        : context.translate('enter_valid_string_with_at_least_8_character');
  }

  String? isNumberValid(String? string) {
    try {
      num.parse(string ?? "");
      return null;
    } catch (e) {
      return context.translate('please_enter_valid_number');
    }
  }

  bool isUserCompany() {
    return !UserRepository().isEmployee();
  }

  void onStartUpdatingAnAds(JobAdvertisement jobAdvertisement) {
    titleController.text = jobAdvertisement.title;
    descriptionController.text = jobAdvertisement.description;
    hoursToWorkInPerDayController.text = jobAdvertisement.workTime.toString();
    yearsOfExperienceController.text = jobAdvertisement.yearsOfExperiences.toString();
    requirementController.text = jobAdvertisement.requirement ?? "";
  }
}
