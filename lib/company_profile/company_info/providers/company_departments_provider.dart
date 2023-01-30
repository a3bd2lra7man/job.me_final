// ignore_for_file: use_build_context_synchronously, body_might_complete_normally_nullable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/entities/image_file.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/extensions/date_extensions.dart';
import 'package:job_me/_shared/extensions/string_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/company_profile/company_info/models/company_info.dart';
import 'package:job_me/company_profile/company_info/models/company_info_form_data.dart';
import 'package:job_me/company_profile/company_info/services/company_departments_fetcher.dart';
import 'package:job_me/company_profile/company_info/services/company_info_updater.dart';

class CompanyInfoProvider extends ChangeNotifier {
  BuildContext context;
  CompanyInfo? companyInfo;
  ImageFile? imageFile;

  CompanyInfoProvider(this.context);

  bool isLoading = false;

  // MARK: services

  final CompanyInfoUpdater _updater = CompanyInfoUpdater();
  final CompanyInfoFetcher _fetcher = CompanyInfoFetcher();

  // MARK: controllers

  final nameController = TextEditingController();
  final notesController = TextEditingController();
  final emailController = TextEditingController();
  final sizeController = TextEditingController();
  final fieldController = TextEditingController();
  DateTime? date;

  // MARK: getting, adding, deleting and updating experience

  Future fetchCompanyInfo() async {
    await _doLongOperation(() async {
      companyInfo = await _fetcher.fetch();
    });
  }

  Future<bool?> updateCompanyInfo() async {
    if (date == null) {
      showSnackBar(body: context.translate("please_select_date"));
      return false;
    }
    return await _doLongOperation(() async {
      var companyInfo = _createCompanyInfoFormData();
      await _updater.update(companyInfo);
      showSnackBar(body: context.translate("saved_successfully"));
      return true;
    });
  }

  CompanyInfoFormData _createCompanyInfoFormData() {
    return CompanyInfoFormData(
        name: nameController.text,
        notes: notesController.text,
        email: emailController.text,
        date: date!.toRawString(),
        field: fieldController.text,
        size: sizeController.text,
        photoFile: imageFile);
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

  onStartUpdatingCompanyInfo() {
    nameController.text = companyInfo!.name ;
    notesController.text = companyInfo!.notes ?? "";
    emailController.text = companyInfo!.email;
    sizeController.text = companyInfo!.size ?? "" ;
    fieldController.text = companyInfo!.field ?? "" ;
    date = companyInfo!.date?.toDate()  ;
  }

  onImageSelected(ImageFile imageFile) {
    this.imageFile = imageFile;
  }

  // MARK: validators

  String? isStringValid(String? string) {
    return string != null && string.isNotEmpty ? null : context.translate('enter_valid_string');
  }

}
