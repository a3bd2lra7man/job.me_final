// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/entities/image_file.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/extensions/date_extensions.dart';
import 'package:job_me/_shared/extensions/string_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/resume_employee/personal_info/models/personal_info_data.dart';
import 'package:job_me/resume_employee/personal_info/services/personal_info_updater.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';

import '../../../_shared/exceptions/app_exception.dart';

class PersonalInfoProvider extends ChangeNotifier {
  BuildContext context;

  PersonalInfoProvider(this.context) {
    var user = _userRepository.getUser();
    countryName = user.country;
    phoneController.text = user.phone ?? '';
    isGenderMan = user.gender?.startsWith('ذكر');
  }

  final UserRepository _userRepository = UserRepository();
  final PersonalInfoUpdater _infoUpdater = PersonalInfoUpdater();
  bool isLoading = false;
  bool? isGenderMan;

  // MARK: controllers

  String? countryName;
  final phoneController = TextEditingController();
  DateTime? birthDay;
  ImageFile? imageFile;

  // MARK: updating profile data

  void onDateSelected(DateTime dateTime) {
    birthDay = dateTime;
  }

  Future updateProfileData() async {
    if (_isGenderNotSelected()) return;
    if (_isCountryNotSelected()) return;
    if (_isBirthDayNotFilled()) return;
    _notify(loading: true);
    try {
      var updateProfileData = _createUpdateProfileData();
      var user = await _infoUpdater.update(updateProfileData);
      await _userRepository.saveUser(user);
      showSnackBar(body: context.translate('saved_successfully'));
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    _notify(loading: false);
  }


  bool _isGenderNotSelected() {
    if (isGenderMan == null) showSnackBar(body: context.translate("please_select_gender"));
    return isGenderMan == null;
  }

  bool _isCountryNotSelected() {
    if (countryName == null) showSnackBar(body: context.translate("please_select_country"));
    return countryName == null;
  }

  bool _isBirthDayNotFilled() {
    var isNotFilled = birthDay == null ? true : false;
    if (isNotFilled) showSnackBar(body: context.translate("please_select_date"));
    return isNotFilled;
  }


  PersonalInfoData _createUpdateProfileData() {
    return PersonalInfoData(
        country: countryName!,
        phone: phoneController.text,
        gender: Gender.fromBoolean(isMan: isGenderMan!),
        dateOfBirth: birthDay!.toRawString(),
        imageFile: imageFile);
  }

  _notify({required bool loading}) {
    isLoading = loading;
    notifyListeners();
  }

  // MARK: validators

  String? isStringValid(String? string) {
    return string != null && string.isNotEmpty ? null : context.translate('enter_valid_string');
  }

  String? isPhoneValid(String? string) {
    if (string == null) return context.translate('enter_valid_number');
    if (string.startsWith('+')) {
      var num = int.tryParse(string.substring(1));
      return num == null ? context.translate('enter_valid_number') : null;
    } else {
      var num = int.tryParse(string);
      return num == null ? context.translate('enter_valid_number') : null;
    }
  }

  // MARK: getters

  String getUserCountry() => _userRepository.getUser().country ?? "";

  String getUserPhone() => _userRepository.getUser().phone ?? "";

  String getUserGender() => _userRepository.getUser().gender ?? "";

  String? getDateOfBirth() => birthDay?.toRawString() ?? _userRepository.getUser().dateOfBirth;

  String? getUserImage() => _userRepository.getUser().image;

  onImageSelected(ImageFile imageFile) {
    this.imageFile = imageFile;
  }

  void onStartUpdating() {
    birthDay = _userRepository.getUser().dateOfBirth?.toDate();
  }

  onGenderSelected({required bool isMan}) {
    isGenderMan = isMan;
    notifyListeners();
  }

  void selectCountry(String countryName) {
    this.countryName = countryName;
    notifyListeners();
  }
}
