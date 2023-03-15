import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/loading_widget.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/home/job_details/providers/job_details_provider.dart';
import 'package:job_me/home/job_details/ui/screens/employee_resume_screen_loader.dart';
import 'package:job_me/home/job_details/ui/widgets/employee_info_header.dart';
import 'package:job_me/home/offers/models/employee_resume_with_application_status_model.dart';
import 'package:job_me/home/offers/providers/company_offers_details_provider.dart';
import 'package:job_me/resume_core/ui/widgets/resume_container.dart';
import 'package:job_me/resume_core/ui/widgets/row_tile.dart';
import 'package:provider/provider.dart';

class AcceptEmployeeApplicationScreen extends StatefulWidget {
  final int jobToApplyId;
  final int employeeId;

  static Widget init(
      {required CompanyOffersDetailsProvider? provider, required int employeeAdId, required int jobToApplyId}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => JobDetailsProvider(jobId: jobToApplyId, context: context)..getJobDetails(),
        ),
        if (provider != null)
          ChangeNotifierProvider.value(
            value: provider,
          ),
        if (provider == null)
          ChangeNotifierProvider(
            create: (context) => CompanyOffersDetailsProvider(context),
          ),
      ],
      child: AcceptEmployeeApplicationScreen._(
        jobToApplyId: jobToApplyId,
        employeeId: employeeAdId,
      ),
    );
  }

  const AcceptEmployeeApplicationScreen._({Key? key, required this.jobToApplyId, required this.employeeId})
      : super(key: key);

  @override
  State<AcceptEmployeeApplicationScreen> createState() => _AcceptEmployeeApplicationScreenState();
}

class _AcceptEmployeeApplicationScreenState extends State<AcceptEmployeeApplicationScreen> {
  EmployeeResumeWithApplyStatusModel? employeeResumeWithApplyStatusModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getEmployeeResumeWithApplicationStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CompanyOffersDetailsProvider>();
    var jobDetailsProvider = context.watch<JobDetailsProvider>();
    return Scaffold(
      appBar: PrimaryAppBar(
        title: context.translate('resume'),
        elevation: 0,
        titleColor: AppColors.black,
      ),
      body: Container(
        color: AppColors.white,
        child: provider.isLoading || employeeResumeWithApplyStatusModel == null || jobDetailsProvider.isLoading
            ? const EmployeeResumeScreenLoader()
            : ListView(
                children: [
                  const SizedBox(height: 40),
                  EmployeeInfoHeader(
                    resume: employeeResumeWithApplyStatusModel!,
                    job: jobDetailsProvider.job,
                  ),
                  const SizedBox(height: 20),
                  ResumeContainer(
                    title: context.translate('educations'),
                    iconData: Icons.add_box_rounded,
                    buttonText: context.translate('add_educations'),
                    children: [
                      ...employeeResumeWithApplyStatusModel!.educations
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
                      ...employeeResumeWithApplyStatusModel!.experience
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
                      ...employeeResumeWithApplyStatusModel!.certificatesOrTrainings
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
                        children: employeeResumeWithApplyStatusModel!.skills
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: employeeResumeWithApplyStatusModel!.isAccepted()
                                ? AppColors.primary
                                : employeeResumeWithApplyStatusModel!.isUnderProcess()
                                    ? AppColors.grey
                                    : Colors.red,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          employeeResumeWithApplyStatusModel!.isAccepted()
                              ? context.translate('offer_accepted')
                              : employeeResumeWithApplyStatusModel!.isUnderProcess()
                                  ? context.translate('in_progress')
                                  : context.translate('refused'),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.primaryButton,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
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
    var isUserAccepted = employeeResumeWithApplyStatusModel!.isAccepted();
    var text = context.translate(isUserAccepted ? 'cancel_offer' : 'accept_offer');
    var color = isUserAccepted ? Colors.red : AppColors.primary;
    var onPressed = _selectOrUnselectAnEmployeeForJob;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: PrimaryButton(
        onPressed: onPressed,
        title: text,
        color: color,
      ),
    );
  }

  Future _selectOrUnselectAnEmployeeForJob() async {
    var provider = context.read<CompanyOffersDetailsProvider>();
    if (employeeResumeWithApplyStatusModel!.isAccepted()) {
      await provider.cancelOffer(widget.jobToApplyId, widget.employeeId);
      _getEmployeeResumeWithApplicationStatus();
    } else {
      await provider.acceptOffer(widget.jobToApplyId, widget.employeeId);
      _getEmployeeResumeWithApplicationStatus();
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
        onPressed: onPressed,
        title: text,
      ),
    );
  }

  void _getEmployeeResumeWithApplicationStatus() async {
    var provider = context.read<CompanyOffersDetailsProvider>();
    employeeResumeWithApplyStatusModel =
        await provider.getEmployeeResumeWithApplicationStatus(widget.employeeId, widget.jobToApplyId);
    setState(() {});
  }
}
