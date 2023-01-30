import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/resume_employee/skills/models/skill.dart';
import 'package:job_me/resume_employee/skills/services/skills_adder.dart';
import 'package:job_me/resume_employee/skills/services/skills_deleter.dart';
import 'package:job_me/resume_employee/skills/services/skills_updater.dart';

class SkillsProvider extends ChangeNotifier {
  BuildContext context;

  SkillsProvider(this.context);

  bool isLoading = false;

  // MARK: services

  final SkillsAdder _adder = SkillsAdder();
  final SkillsUpdater _updater = SkillsUpdater();
  final SkillsDeleter _deleter = SkillsDeleter();

  // MARK: controllers

  final nameController = TextEditingController();

  // MARK: getting, adding, deleting and updating skill

  Future addSkill() async {
    return await _doLongOperation(() async {
      var skill = _createSkill();
      await _adder.addSkill(skill);
      return true;
    });
  }

  Future updateSkill(int id) async {
    await _doLongOperation(() async {
      var skill = _createSkill();
      skill.id = id;
      await _updater.updateSkill(skill);
    });
  }

  Future deleteSkill(int id) async {
    await _doLongOperation(() async {
      await _deleter.deleteSkill(id);
    });
  }

  Skill _createSkill() {
    return Skill(name: nameController.text);
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

  onAddNewSkill() {
    nameController.text = "";
  }
}
