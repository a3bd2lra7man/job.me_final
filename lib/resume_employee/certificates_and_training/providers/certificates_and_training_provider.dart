// ignore_for_file: use_build_context_synchronously, body_might_complete_normally_nullable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/extensions/date_extensions.dart';
import 'package:job_me/_shared/extensions/string_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/resume_employee/certificates_and_training/models/certificate_or_training.dart';
import 'package:job_me/resume_employee/certificates_and_training/services/certificates_and_trainings_adder.dart';
import 'package:job_me/resume_employee/certificates_and_training/services/certificates_and_trainings_deleter.dart';
import 'package:job_me/resume_employee/certificates_and_training/services/certificates_and_trainings_updater.dart';

class CertificatesAndTrainingsProvider extends ChangeNotifier {
  BuildContext context;

  CertificatesAndTrainingsProvider(this.context);

  bool isLoading = false;

  // MARK: services

  final CertificatesAndTrainingsAdder _adder = CertificatesAndTrainingsAdder();
  final CertificatesAndTrainingsUpdater _updater = CertificatesAndTrainingsUpdater();
  final CertificatesAndTrainingsDeleter _deleter = CertificatesAndTrainingsDeleter();

  // MARK: controllers

  final nameController = TextEditingController();
  final filedController = TextEditingController();
  final providerNameController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? date;

  // MARK: getting, adding, deleting and updating experience

  Future<bool?> addCertificateOrTraining() async {
    if (date == null) {
      showSnackBar(body: context.translate("please_select_date"));
      return false;
    }
    return await _doLongOperation(() async {
      var certificateOrTraining = _createCertificateOrTraining();
      await _adder.addCertificateOrTraining(certificateOrTraining);
      showSnackBar(body: context.translate("saved_successfully"));
      return true;
    });
  }

  Future<bool?> updateCertificateOrTraining(int id) async {
    return await _doLongOperation(() async {
      var certificateOrTraining = _createCertificateOrTraining();
      certificateOrTraining.id = id;
      await _updater.updateCertificateOrTraining(certificateOrTraining);
      showSnackBar(body: context.translate("saved_successfully"));
      return true;
    });
  }

  Future deleteCertificateOrTraining(int id) async {
    await _doLongOperation(() async {
      await _deleter.deleteCertificateOrTraining(id);
    });
  }

  CertificateOrTraining _createCertificateOrTraining() {
    return CertificateOrTraining(
      name: nameController.text,
      field: filedController.text,
      providerName: providerNameController.text,
      date: date!.toRawString(),
      description: descriptionController.text,
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

  onStartAddingNewCertificateOrTraining() {
    nameController.text = "";
    filedController.text = "";
    providerNameController.text = "";
    descriptionController.text = "";
    date = null;
  }

  onStartUpdatingCertificateOrTraining(CertificateOrTraining certificateOrTraining) {
    nameController.text = certificateOrTraining.name;
    filedController.text = certificateOrTraining.field;
    providerNameController.text = certificateOrTraining.providerName;
    descriptionController.text = certificateOrTraining.description;
    date = certificateOrTraining.date.toDate();
  }

  // MARK: validators

  String? isStringValid(String? string) {
    return string != null && string.length > 1 ? null : context.translate('enter_valid_string');
  }
}
