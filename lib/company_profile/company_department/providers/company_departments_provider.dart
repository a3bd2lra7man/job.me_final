// ignore_for_file: use_build_context_synchronously, body_might_complete_normally_nullable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/company_profile/company_department/models/company_department.dart';
import 'package:job_me/company_profile/company_department/services/company_department_adder.dart';
import 'package:job_me/company_profile/company_department/services/company_department_deleter.dart';
import 'package:job_me/company_profile/company_department/services/company_department_updater.dart';

class CompanyDepartmentProvider extends ChangeNotifier {
  BuildContext context;

  CompanyDepartmentProvider(this.context);

  bool isLoading = false;

  // MARK: services

  final CompanyDepartmentAdder _adder = CompanyDepartmentAdder();
  final CompanyDepartmentUpdater _updater = CompanyDepartmentUpdater();
  final CompanyDepartmentDeleter _deleter = CompanyDepartmentDeleter();

  // MARK: controllers

  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final employeeCountController = TextEditingController();

  // MARK: getting, adding, deleting and updating experience

  Future<bool?> addCompanyDepartment(int companyId) async {
    return await _doLongOperation(() async {
      var companyDepartment = _createCompanyDepartment();
      await _adder.addCompanyDepartment(companyId,companyDepartment);
      showSnackBar(body: context.translate("saved_successfully"));
      return true;
    });
  }

  Future<bool?> updateCompanyDepartment(int id) async {
    return await _doLongOperation(() async {
      var companyDepartment = _createCompanyDepartment();
      companyDepartment.id = id;
      await _updater.updateCompanyDepartment(companyDepartment);
      showSnackBar(body: context.translate("saved_successfully"));
      return true;
    });
  }

  Future deleteCompanyDepartment(int id) async {
    await _doLongOperation(() async {
      await _deleter.deleteCompanyDepartment(id);
    });
  }

  CompanyDepartment _createCompanyDepartment() {
    return CompanyDepartment(
      country: countryController.text,
      city: cityController.text,
      employeesCount: num.parse(employeeCountController.text),
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

  onStartAddingNewCompanyDepartment() {
    countryController.text = "";
    cityController.text = "";
    employeeCountController.text = "";
  }

  onStartUpdatingCompanyDepartment(CompanyDepartment companyDepartment) {
    countryController.text = companyDepartment.country;
    cityController.text = companyDepartment.city;
    employeeCountController.text = companyDepartment.employeesCount.toString();
  }

  // MARK: validators

  String? isStringValid(String? string) {
    return string != null && string.length > 1 ? null : context.translate('enter_valid_string');
  }

  String? isNumberValid(String? string) {
    try {
      num.parse(string ?? "");
      return null;
    } catch (e) {
      return context.translate('please_enter_valid_number');
    }
  }
}
