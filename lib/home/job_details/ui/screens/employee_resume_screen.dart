import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/loading_widget.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/home/job_details/providers/job_details_provider.dart';
import 'package:job_me/home/job_details/ui/screens/employee_resume_screen_loader.dart';
import 'package:job_me/home/job_details/ui/widgets/employee_info_header.dart';
import 'package:job_me/home/job_details/ui/widgets/job_for_employee_picker.dart';
import 'package:job_me/resume_core/ui/widgets/resume_container.dart';
import 'package:job_me/resume_core/ui/widgets/row_tile.dart';
import 'package:provider/provider.dart';

import '../../../../_utils/check_is_user_logged_in.dart';

class EmployeeResumeScreen extends StatefulWidget {
  static Widget init({required int employeeAdId}) {
    return ChangeNotifierProvider(
      create: (context) => JobDetailsProvider(
        context: context,
        jobId: employeeAdId,
      ),
      child: const EmployeeResumeScreen._(),
    );
  }

  const EmployeeResumeScreen._({Key? key}) : super(key: key);

  @override
  State<EmployeeResumeScreen> createState() => _EmployeeResumeScreenState();
}

class _EmployeeResumeScreenState extends State<EmployeeResumeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<JobDetailsProvider>().fetchEmployeeDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<JobDetailsProvider>();
    var resume = provider.resume;
    return Scaffold(
      appBar: PrimaryAppBar(
        title: context.translate('resume'),
        elevation: 0,
        titleColor: AppColors.black,
      ),
      body: Container(
        color: AppColors.white,
        child: provider.isLoading && resume == null
            ? const EmployeeResumeScreenLoader()
            : ListView(
                children: [
                  const SizedBox(height: 40),
                  EmployeeInfoHeader(resume: resume!, job: provider.job),
                  const SizedBox(height: 20),
                  ResumeContainer(
                    title: context.translate('educations'),
                    iconData: Icons.add_box_rounded,
                    buttonText: context.translate('add_educations'),
                    children: [
                      ...resume.educations
                          .map(
                            (education) => Column(
                              children: [
                                const SizedBox(height: 16),
                                RowTile(
                                    title: context.translate('facility_of_education'),
                                    subTitle: education.universityName),
                                RowTile(title: context.translate('college'), subTitle: education.specialization),
                                RowTile(title: context.translate('higher_education'), subTitle: education.level),
                                RowTile(
                                  title: context.translate('date'),
                                  subTitle: "${education.startDate} -> ${education.endDate}",
                                  textStyle: AppTextStyles.smallStyle,
                                ),
                              ],
                            ),
                          )
                          .toList()
                    ],
                  ),
                  const SizedBox(height: 20),
                  ResumeContainer(
                    title: context.translate('experience'),
                    iconData: Icons.add_box_rounded,
                    buttonText: context.translate('add_experience'),
                    children: [
                      ...resume.experience
                          .map(
                            (experience) => Column(
                              children: [
                                const SizedBox(height: 16),
                                RowTile(title: context.translate('facility'), subTitle: experience.enterpriseName),
                                RowTile(title: context.translate('job_title'), subTitle: experience.jobName),
                                RowTile(title: context.translate('field'), subTitle: experience.field),
                                RowTile(
                                  title: context.translate('date'),
                                  subTitle: "${experience.startDate} -> ${experience.endDate}",
                                  textStyle: AppTextStyles.smallStyle,
                                ),
                              ],
                            ),
                          )
                          .toList()
                    ],
                  ),
                  const SizedBox(height: 20),
                  ResumeContainer(
                    title: context.translate('certificates_and_trainings'),
                    iconData: Icons.add_box_rounded,
                    buttonText: context.translate('add_certificates_or_trainings'),
                    children: [
                      ...resume.certificatesOrTrainings
                          .map(
                            (certificatesOrTraining) => Column(
                              children: [
                                const SizedBox(height: 16),
                                RowTile(
                                    title: context.translate('certificate_name'),
                                    subTitle: certificatesOrTraining.name),
                                RowTile(
                                    title: context.translate('certificate_provider_name'),
                                    subTitle: certificatesOrTraining.providerName),
                                RowTile(title: context.translate('field'), subTitle: certificatesOrTraining.field),
                                RowTile(title: context.translate('date'), subTitle: certificatesOrTraining.date),
                              ],
                            ),
                          )
                          .toList()
                    ],
                  ),
                  const SizedBox(height: 20),
                  ResumeContainer(
                    title: context.translate('skills'),
                    iconData: Icons.add_box_rounded,
                    buttonText: context.translate('add_skill'),
                    children: [
                      const SizedBox(height: 16),
                      Wrap(
                        direction: Axis.horizontal,
                        children: resume.skills
                            .map(
                              (skill) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Chip(
                                  deleteIcon: Icon(
                                    Icons.delete_outline_rounded,
                                    color: AppColors.darkGrey,
                                    size: 20,
                                  ),
                                  backgroundColor: AppColors.primary.withOpacity(.5),
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(width: 2),
                                      Text(
                                        skill.name,
                                        style: AppTextStyles.hintBold.copyWith(color: AppColors.darkGrey),
                                      ),
                                      const SizedBox(width: 2),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  provider.isTransactionLoading
                      ? const LoadingWidget()
                      : Column(
                          children: [
                            _getApplyButton(),
                            const SizedBox(height: 20),
                            _getAddToFavoriteButton(),
                          ],
                        ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _getApplyButton() {
    var provider = context.read<JobDetailsProvider>();
    var text = context.translate(provider.job.isApplied ? 'cancel_from_applied_job' : 'ask_for_employment');
    var onPressed = provider.job.isApplied ? provider.cancelApplyingToJob : _selectAnEmployeeForJob;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: PrimaryButton(
        onPressed: ()=> _checkUserLoggedInAndDo(onPressed),
        title: text,
      ),
    );
  }

  Future _selectAnEmployeeForJob() async {
    var provider = context.read<JobDetailsProvider>();
    var selectedJobId = await Get.to(JobForEmployeePicker(
      employeeId: provider.job.userId!,
    ));
    if (selectedJobId != null) {
      await provider.pickAnEmployeeForJob(selectedJobId);
      await provider.fetchEmployeeDetails();
    }
  }

  Widget _getAddToFavoriteButton() {
    var provider = context.read<JobDetailsProvider>();
    var text = context.translate(provider.job.isSaved ? 'cancel_save_employee' : 'save_employee');
    var onPressed = provider.job.isSaved ? provider.removeJobFromSavedList : provider.addJobToSavedList;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: PrimaryButton(
        titleColor: AppColors.primary,
        color: AppColors.white,
        onPressed:()=> _checkUserLoggedInAndDo(onPressed),
        title: text,
      ),
    );
  }

  void _checkUserLoggedInAndDo(Function doo) {
    if (isUserNotLoggedIn(context)) return;
    doo();
  }
}
