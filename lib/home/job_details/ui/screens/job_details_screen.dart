import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/loading_widget.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/_utils/check_is_user_logged_in.dart';
import 'package:job_me/home/home/providers/home_provider.dart';
import 'package:job_me/home/job_details/providers/job_details_provider.dart';
import 'package:job_me/home/job_details/ui/screens/job_details_screen_loader.dart';
import 'package:job_me/home/job_details/ui/widgets/job_details_header.dart';
import 'package:provider/provider.dart';

class JobDetailsScreen extends StatefulWidget {
  static Widget init({required int jobId}) {
    return ChangeNotifierProvider(
        create: (context) => JobDetailsProvider(context: context, jobId: jobId), child: const JobDetailsScreen._());
  }

  const JobDetailsScreen._({Key? key}) : super(key: key);

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<JobDetailsProvider>().getJobDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<JobDetailsProvider>();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PrimaryAppBar(
        elevation: 0,
        title: context.translate('job_details'),
        titleColor: AppColors.black,
        actions: _getActionButton(provider),
      ),
      body: provider.isLoading
          ? const JobDetailsScreenLoader()
          : Builder(
              builder: (context) => ListView(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  JobDetailsHeader(job: provider.job),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      context.translate('job_description'),
                      style: AppTextStyles.titleBold,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      provider.job.description,
                      style: AppTextStyles.hint.copyWith(color: AppColors.darkGrey),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  if (provider.job.requirement != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        context.translate('job_requirements'),
                        style: AppTextStyles.titleBold,
                      ),
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                  if (provider.job.requirement != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        provider.job.requirement!,
                        style: AppTextStyles.hint.copyWith(color: AppColors.darkGrey),
                      ),
                    ),
                  const SizedBox(
                    height: 40,
                  ),
                  provider.isTransactionLoading
                      ? const LoadingWidget()
                      : Column(
                          children: [
                            provider.job.isApplied
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    decoration: BoxDecoration(
                                        color: Colors.green[300], borderRadius: BorderRadius.circular(20)),
                                    child: Text(
                                      context.translate('job_applied_successfully'),
                                      style: AppTextStyles.primaryButton,
                                    ),
                                  )
                                : _getApplyButton(),
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

  List<Widget>? _getActionButton(JobDetailsProvider provider) {
    if (provider.isLoading) return null;
    var icon = provider.job.isSaved ? Icons.bookmark : Icons.bookmark_border;
    var onPressed = provider.job.isSaved ? provider.removeJobFromSavedList : provider.addJobToSavedList;
    return [
      IconButton(
        onPressed: () => _checkUserLoggedInAndDo(onPressed),
        icon: Icon(icon, color: AppColors.black),
      ),
    ];
  }

  Widget _getApplyButton() {
    var provider = context.read<JobDetailsProvider>();
    var text = context.translate(provider.job.isApplied ? 'cancel_apply_for_job' : 'apply_for_job');
    var onPressed = provider.job.isApplied ? provider.cancelApplyingToJob : provider.applyForJob;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: PrimaryButton(
        onPressed: () => _checkUserLoggedInAndDo(onPressed),
        title: text,
      ),
    );
  }

  Widget _getAddToFavoriteButton() {
    var provider = context.read<JobDetailsProvider>();
    var text = context.translate(provider.job.isSaved ? 'cancel_from_saved_job' : 'save_job');
    var onPressed = provider.job.isSaved ? provider.removeJobFromSavedList : provider.addJobToSavedList;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: PrimaryButton(
        color: AppColors.white,
        titleColor: AppColors.primary,
        onPressed: () => _checkUserLoggedInAndDo(() async {
          var isChanged = await onPressed();
          if (isChanged && mounted) {
            var homeProvider = context.read<HomePageProvider>();
            homeProvider.changeSelectedPageTo(HomePages.saved);
          }
        }),
        title: text,
      ),
    );
  }

  void _checkUserLoggedInAndDo(Function doo) {
    if (isUserNotLoggedIn(context)) return;
    doo();
  }
}
