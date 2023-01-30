// ignore_for_file: use_build_context_synchronously, body_might_complete_normally_nullable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/extensions/date_extensions.dart';
import 'package:job_me/_shared/extensions/string_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/resume_employee/experiences/models/experience.dart';
import 'package:job_me/resume_employee/experiences/services/experiences_adder.dart';
import 'package:job_me/resume_employee/experiences/services/experiences_deleter.dart';
import 'package:job_me/resume_employee/experiences/services/experiences_updater.dart';

class ExperiencesProvider extends ChangeNotifier {
  BuildContext context;

  ExperiencesProvider(this.context);

  bool isLoading = false;

  // MARK: services

  final ExperiencesAdder _adder = ExperiencesAdder();
  final ExperiencesUpdater _updater = ExperiencesUpdater();
  final ExperiencesDeleter _deleter = ExperiencesDeleter();

  // MARK: controllers

  final jobNameController = TextEditingController();
  final filedController = TextEditingController();
  final enterpriseNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final countryController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  // MARK: getting, adding, deleting and updating experience

  Future<bool?> addExperience() async {
    if (startDate == null || endDate == null) {
      showSnackBar(body: context.translate("please_select_date"));
      return null;
    }
    return await _doLongOperation(() async {
      var experience = _createExperience();
      await _adder.addExperience(experience);
      showSnackBar(body: context.translate("saved_successfully"));
      return true;
    });
  }

  Future<bool?> updateExperience(int id) async {
    return await _doLongOperation(() async {
      var experience = _createExperience();
      experience.id = id;
      await _updater.updateExperience(experience);
      showSnackBar(body: context.translate("saved_successfully"));
      return true;
    });
  }

  Future deleteExperience(int id) async {
    await _doLongOperation(() async {
      await _deleter.deleteExperience(id);
    });
  }

  Experience _createExperience() {
    return Experience(
      jobName: jobNameController.text,
      field: filedController.text,
      enterpriseName: enterpriseNameController.text,
      startDate: startDate!.toRawString(),
      endDate: endDate!.toRawString(),
      description: descriptionController.text,
      country: countryController.text,
    );
  }

  Future _doLongOperation(Future Function() doo) async {
    isLoading = true;
    notifyListeners();
    try {
      var res = await doo();
      notifyListeners();
      isLoading = false;
      return res;
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    isLoading = false;
    notifyListeners();
  }

  // MARK: navigation functions

  onStartAddingNewExperience() {
    jobNameController.text = "";
    filedController.text = "";
    enterpriseNameController.text = "";
    descriptionController.text = "";
    countryController.text = "";
    startDate = null;
    endDate = null;
  }

  onStartUpdatingExperience(Experience experience) {
    jobNameController.text = experience.jobName;
    filedController.text = experience.field;
    enterpriseNameController.text = experience.enterpriseName;
    countryController.text = experience.country;
    descriptionController.text = experience.description;
    startDate = experience.startDate.toDate();
    endDate = experience.endDate.toDate();
  }

  // MARK: validators

  String? isStringValid(String? string) {
    return string != null && string.length > 1 ? null : context.translate('enter_valid_string');
  }

  String? isCountryValid(String? string) {
    return string != null && string.length >= 2 ? null : context.translate('enter_valid_string');
  }
}
