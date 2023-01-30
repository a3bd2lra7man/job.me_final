// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/home/job_details/models/job_ads_details.dart';
import 'package:job_me/home/job_details/services/job_applyier.dart';
import 'package:job_me/home/job_details/services/job_canceler.dart';
import 'package:job_me/home/job_details/services/job_saver.dart';
import 'package:job_me/home/job_details/services/jobs_fetcher.dart';
import 'package:job_me/resume_core/models/resume.dart';
import 'package:job_me/resume_core/services/resume_fetcher.dart';

class JobDetailsProvider extends ChangeNotifier {
  Resume? resume;
  final int jobId;
  final BuildContext context;
  late JobAdsDetails job;
  final JobDetailsFetcher _detailsFetcher = JobDetailsFetcher();
  final JobSaver _jobSaver = JobSaver();
  final JobApplier _jobApplier = JobApplier();
  final JobCanceler _jobCanceler = JobCanceler();
  final ResumeFetcher _resumeFetcher = ResumeFetcher();
  bool isLoading = true;
  bool isTransactionLoading = false;

  JobDetailsProvider({required this.jobId, required this.context});

  Future getJobDetails() async {
    _doLongOperation(() async {
      job = await _detailsFetcher.getJobDetails(jobId);
    });
  }

  Future addJobToSavedList() async {
    return await _doLongTransactionOperation(() async {
      await _jobSaver.addJobToSavedList(job.id);
      showSnackBar(body: context.translate('job_saved_successfully'));
      await getJobDetails();
    });
  }

  Future removeJobFromSavedList() async {
    return _doLongTransactionOperation(() async {
      await _jobSaver.removeJobFromSavedList(job.id);
      showSnackBar(body: context.translate('job_saved_canceled_successfully'));
      await getJobDetails();
    });
  }

  Future applyForJob() async {
    _doLongTransactionOperation(() async {
      await _jobApplier.applyForJob(jobId);
      showSnackBar(body: context.translate('job_applied_successfully'));
      await getJobDetails();
    });
  }

  Future cancelApplyingToJob() async {
    _doLongTransactionOperation(() async {
      await _jobCanceler.cancelJob(jobId);
      await getJobDetails();
    });
  }

  Future fetchEmployeeDetails() async {
    _doLongOperation(() async {
      job = await _detailsFetcher.getJobDetails(jobId);
      resume = await _resumeFetcher.getResume(job.userId!);
    });
  }

  pickAnEmployeeForJob(int selectedJobId) {
    _doLongTransactionOperation(() async {
      await _jobApplier.pickEmployee(selectedJobId, job.userId!);
      showSnackBar(body: context.translate('successfully_pick_employee'));
    });
  }

  Future _doLongOperation(Future Function() doo) async {
    isLoading = true;
    notifyListeners();

    try {
      await doo();
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    isLoading = false;
    notifyListeners();
  }

  Future _doLongTransactionOperation(Future Function() doo) async {
    isTransactionLoading = true;
    notifyListeners();

    try {
      var res = await doo();
      isTransactionLoading = false;
      isTransactionLoading = false;
      notifyListeners();
      return res;
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    isTransactionLoading = false;
    notifyListeners();
  }
}
