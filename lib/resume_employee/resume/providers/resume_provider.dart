import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/resume_core/models/resume.dart';
import 'package:job_me/resume_core/services/resume_fetcher.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';

class ResumeProvider extends ChangeNotifier {
  BuildContext context;
  late Resume resume;
  bool isLoading = true;

  final ResumeFetcher _fetcher = ResumeFetcher();

  ResumeProvider(this.context);

  Future fetchResume() async {
    isLoading = true;
    notifyListeners();
    try {
      var userId = UserRepository().getUser().id;
      resume = await _fetcher.getResume(userId);
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    isLoading = false;
    notifyListeners();
  }
}
