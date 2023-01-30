import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/home/main/providers/recent_job_provider.dart';
import 'package:job_me/home/main/providers/special_job_provider.dart';
import 'package:job_me/home/main/ui/widgets/recent_ads_jobs_widget.dart';
import 'package:job_me/home/main/ui/widgets/special_ads_jobs_widget.dart';
import 'package:provider/provider.dart';

class CompanyMainPage extends StatefulWidget {
  static Widget init() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RecentJobProvider(context)),
        ChangeNotifierProvider(create: (context) => SpecialJobProvider(context)),
      ],
      child: const CompanyMainPage._(),
    );
  }

  const CompanyMainPage._({Key? key}) : super(key: key);

  @override
  State<CompanyMainPage> createState() => _CompanyMainPageState();
}

class _CompanyMainPageState extends State<CompanyMainPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getSpecialAndRecentJobs();
    });
  }

  Future _getSpecialAndRecentJobs() async {
    context.read<RecentJobProvider>().getNextJobs();
    context.read<SpecialJobProvider>().getNextJobs();
  }

  @override
  Widget build(BuildContext context) {
    var specialJobsProvider = context.watch<SpecialJobProvider>();
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _getSpecialAndRecentJobs,
      child: Container(
        color: AppColors.primary.withOpacity(.04),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                context.translate('employee_special_ads'),
                style: AppTextStyles.titleBold,
              ),
              Visibility(
                visible: (specialJobsProvider.jobs.isEmpty && !specialJobsProvider.isFirstLoading),
                child: SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      context.translate('no_special_jobs_now'),
                      style: AppTextStyles.titleBold.copyWith(color: AppColors.darkGrey),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !(specialJobsProvider.jobs.isEmpty && !specialJobsProvider.isFirstLoading),
                child: const SpecialAdsJobsWidget(),
              ),
              const SizedBox(height: 16),
              Text(
                context.translate('employee_normal_ads'),
                style: AppTextStyles.titleBold,
              ),
              const SizedBox(height: 4),
              const Expanded(child: RecentAdsJobsWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
