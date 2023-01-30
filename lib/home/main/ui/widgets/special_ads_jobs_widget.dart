import 'package:flutter/material.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/home/main/providers/special_job_provider.dart';
import 'package:job_me/home/main/ui/widgets/special_ads_job_card.dart';
import 'package:job_me/home/main/ui/widgets/special_jobs_loader.dart';
import 'package:provider/provider.dart';

class SpecialAdsJobsWidget extends StatefulWidget {
  const SpecialAdsJobsWidget({Key? key}) : super(key: key);

  @override
  State<SpecialAdsJobsWidget> createState() => _SpecialAdsJobsWidgetState();
}

class _SpecialAdsJobsWidgetState extends State<SpecialAdsJobsWidget> {
  final _specialJobsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _specialJobsScrollController.addListener(() {
      if (_specialJobsScrollController.position.pixels == _specialJobsScrollController.position.maxScrollExtent) {
        context.read<SpecialJobProvider>().getNextJobs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var specialJobsProvider = context.watch<SpecialJobProvider>();
    return specialJobsProvider.isFirstLoading
        ? const SpecialJobsLoader()
        : SizedBox(
            height: 220,
            child: ListView(
              controller: _specialJobsScrollController,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              children: [
                ...specialJobsProvider.jobs
                    .map(
                      (job) => SpecialAdJobCard(
                        job: job,
                      ),
                    )
                    .toList(),
                const SizedBox(width: 20),
                Visibility(
                  visible: specialJobsProvider.isPaginationLoading,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
