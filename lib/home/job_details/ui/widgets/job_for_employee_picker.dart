import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/loading_widget.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/home/_shared/models/job_ad_with_appliers.dart';
import 'package:job_me/home/job_details/services/company_job_fetcher.dart';

class JobForEmployeePicker extends StatefulWidget {
  final int employeeId;

  const JobForEmployeePicker({Key? key, required this.employeeId}) : super(key: key);

  @override
  _JobForEmployeePickerState createState() => _JobForEmployeePickerState();
}

class _JobForEmployeePickerState extends State<JobForEmployeePicker> {
  bool isLoading = false;

  int? selectedJobId;

  final CompanyJobsFetcher companyJobsFetcher = CompanyJobsFetcher();

  List<JobAdWithAppliers>? jobs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getCompanyJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: context.translate('pick_a_job_for_employee'),
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: selectedJobId == null
          ? null
          : PrimaryButton(
              onPressed: () {
                Get.back(result: selectedJobId);
              },
              title: context.translate('pick_the_job_for_employee'),
            ),
      body: Center(
        child: Container(
          color: AppColors.primary.withOpacity(.04),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              isLoading || jobs == null
                  ? const Center(
                      child: LoadingWidget(),
                    )
                  : jobs!.isEmpty
                      ? Text(
                          context.translate('you_do_not_have_jobs'),
                          style: AppTextStyles.titleBold.copyWith(color: AppColors.primary),
                          textAlign: TextAlign.center,
                        )
                      : Column(
                          children: jobs!
                              .map(
                                (job) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedJobId = job.jobAdvertisement.id;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                job.jobAdvertisement.title,
                                                style: AppTextStyles.titleBold.copyWith(color: AppColors.black),
                                              ),
                                            ),
                                            job.isEmployeeApplied(widget.employeeId)
                                                ? Expanded(
                                                    child: Text(
                                                      context.translate('already_selected_employee_here'),
                                                      style: AppTextStyles.hint.copyWith(color: AppColors.primary),
                                                      textAlign: TextAlign.end,
                                                    ),
                                                  )
                                                : IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedJobId = job.jobAdvertisement.id;
                                                      });
                                                    },
                                                    icon: Icon(
                                                      selectedJobId == job.jobAdvertisement.id
                                                          ? Icons.radio_button_checked
                                                          : Icons.radio_button_off_outlined,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  void _getCompanyJobs() async {
    setState(() {
      isLoading = true;
    });
    jobs = await companyJobsFetcher.getNextCompanyAds();
    setState(() {
      isLoading = false;
    });
  }
}
