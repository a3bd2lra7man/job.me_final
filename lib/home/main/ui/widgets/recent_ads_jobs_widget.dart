import 'package:flutter/material.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/home/_shared/widgets/job_card.dart';
import 'package:job_me/home/main/providers/recent_job_provider.dart';
import 'package:job_me/home/main/ui/widgets/recent_job_loader.dart';
import 'package:provider/provider.dart';

class RecentAdsJobsWidget extends StatefulWidget {
  const RecentAdsJobsWidget({Key? key}) : super(key: key);

  @override
  State<RecentAdsJobsWidget> createState() => _RecentAdsJobsWidgetState();
}

class _RecentAdsJobsWidgetState extends State<RecentAdsJobsWidget> {
  final _recentJobsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _recentJobsScrollController.addListener(() {
      if (_recentJobsScrollController.position.pixels == _recentJobsScrollController.position.maxScrollExtent) {
        context.read<RecentJobProvider>().getNextJobs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var recentJobsProvider = context.watch<RecentJobProvider>();

    return recentJobsProvider.isFirstLoading
        ? const RecentJobLoader()
        : ListView(
            shrinkWrap: true,
            controller: _recentJobsScrollController,
            children: [
              ...recentJobsProvider.jobs
                  .map(
                    (job) => JobCard(
                      job: job,
                    ),
                  )
                  .toList(),
              const SizedBox(height: 40),
              Visibility(
                visible: recentJobsProvider.isPaginationLoading,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 60),
            ],
          );
  }
}
