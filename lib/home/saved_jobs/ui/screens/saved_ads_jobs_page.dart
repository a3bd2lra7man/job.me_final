import 'package:flutter/material.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_utils/check_is_user_logged_in.dart';
import 'package:job_me/home/_shared/widgets/job_card.dart';
import 'package:job_me/home/saved_jobs/providers/saved_jobs_provider.dart';
import 'package:job_me/home/saved_jobs/ui/widgets/saved_jobs_loader.dart';
import 'package:provider/provider.dart';

class SavedAdsJobsScreen extends StatefulWidget {
  static Widget init() {
    return ChangeNotifierProvider(
      create: (context) => SavedJobsProvider(context),
      child: const SavedAdsJobsScreen._(),
    );
  }

  const SavedAdsJobsScreen._({Key? key}) : super(key: key);

  @override
  State<SavedAdsJobsScreen> createState() => _SavedAdsJobsScreenState();
}

class _SavedAdsJobsScreenState extends State<SavedAdsJobsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (isUserNotLoggedIn(context)) return;
      context.read<SavedJobsProvider>().getNextSavedJobs();
    });
    _setupScrollDownToLoadMoreItems();
  }

  void _setupScrollDownToLoadMoreItems() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        context.read<SavedJobsProvider>().getNextSavedJobs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<SavedJobsProvider>();
    return provider.isFirstLoading
        ? const SavedJobsPageLoader()
        : ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const SizedBox(height: 16),
              Column(
                children: provider.savedJobs
                    .map(
                      (job) => JobCard(
                        job: job,
                        height: 120,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: provider.isPaginationLoading,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          );
  }
}
