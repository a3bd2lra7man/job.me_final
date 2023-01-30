// ignore_for_file: use_build_context_synchronously, body_might_complete_normally_nullable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/extensions/date_extensions.dart';
import 'package:job_me/_shared/extensions/string_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/resume_employee/educations/models/education.dart';
import 'package:job_me/resume_employee/educations/services/educations_adder.dart';
import 'package:job_me/resume_employee/educations/services/educations_deleter.dart';
import 'package:job_me/resume_employee/educations/services/educations_updater.dart';

class EducationsProvider extends ChangeNotifier {
  BuildContext context;

  EducationsProvider(this.context);

  bool isLoading = false;

  // MARK: services

  final EducationsAdder _adder = EducationsAdder();
  final EducationsUpdater _updater = EducationsUpdater();
  final EducationsDeleter _deleter = EducationsDeleter();

  // MARK: controllers

  final universityNameController = TextEditingController();
  final levelController = TextEditingController();
  final specializationController = TextEditingController();
  final markController = TextEditingController();
  final countryController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  // MARK: getting, adding, deleting and updating education

  Future<bool?> addEducation() async {
    if (startDate == null || endDate == null) {
      showSnackBar(body: context.translate("please_select_date"));
      return null;
    }
    return await _doLongOperation(() async {
      var education = _createEducation();
      await _adder.addEducation(education);
      showSnackBar(body: context.translate("saved_successfully"));
      return true;
    });
  }

  Future<bool?> updateEducation(int id) async {
    return await _doLongOperation(() async {
      var education = _createEducation();
      education.id = id;
      await _updater.updateEducation(education);
      showSnackBar(body: context.translate("saved_successfully"));
      return true;
    });
  }

  Future deleteEducation(int id) async {
    await _doLongOperation(() async {
      await _deleter.deleteEducation(id);
    });
  }

  Education _createEducation() {
    return Education(
      universityName: universityNameController.text,
      level: levelController.text,
      specialization: specializationController.text,
      startDate: startDate!.toRawString(),
      endDate: endDate!.toRawString(),
      mark: markController.text,
      country: countryController.text,
    );
  }

  Future _doLongOperation(Future Function() doo) async {
    isLoading = true;
    notifyListeners();
    try {
      var res = await doo();
      isLoading = false;
      notifyListeners();
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

  onStartAddingEducation() {
    universityNameController.text = "";
    levelController.text = "";
    specializationController.text = "";
    countryController.text = "";
    markController.text = "";
    startDate = null;
    endDate = null;
  }

  onStartUpdatingEducation(Education education) {
    universityNameController.text = education.universityName;
    levelController.text = education.level;
    specializationController.text = education.specialization;
    countryController.text = education.country;
    markController.text = education.mark;
    startDate = education.startDate.toDate();
    endDate = education.endDate.toDate();
  }

  // MARK: validators

  String? isStringValid(String? string) {
    return string != null && string.length > 1 ? null : context.translate('enter_valid_string');
  }

  String? isMarkValid(String? string) {
    return string != null && string.length >= 2 ? null : context.translate('enter_valid_string');
  }

  String? isCountryValid(String? string) {
    return string != null && string.length >= 2 ? null : context.translate('enter_valid_string');
  }
}
