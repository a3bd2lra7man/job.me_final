import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/home/job_details/ui/screens/job_details_screen_loader.dart';
import 'package:job_me/home/notifications/providers/company_job_details_provider.dart';
import 'package:job_me/home/offers/ui/widget/company_job_details_header.dart';
import 'package:job_me/home/offers/ui/widget/employee_offer_to_company_job_card.dart';
import 'package:provider/provider.dart';

class CompanyJobWithOfferDetailsScreen extends StatefulWidget {
  final int jobId;

  static Widget init(int jobId) {
    return ChangeNotifierProvider(
      create: (context) => CompanyJobDetailsProvider(context),
      child: CompanyJobWithOfferDetailsScreen._(
        jobId: jobId,
      ),
    );
  }

  const CompanyJobWithOfferDetailsScreen._({Key? key, required this.jobId}) : super(key: key);

  @override
  State<CompanyJobWithOfferDetailsScreen> createState() => _CompanyJobWithOfferDetailsScreenState();
}

class _CompanyJobWithOfferDetailsScreenState extends State<CompanyJobWithOfferDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CompanyJobDetailsProvider>().getJobDetails(widget.jobId);
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CompanyJobDetailsProvider>();
    var companyOfferDetails = provider.companyOfferDetails;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PrimaryAppBar(
        elevation: 0,
        title: context.translate('job_details'),
        titleColor: AppColors.black,
      ),
      body: provider.isLoading || companyOfferDetails == null
          ? const JobDetailsScreenLoader()
          : ListView(
              children: [
                const SizedBox(
                  height: 40,
                ),
                CompanyJobDetailsHeader(job: companyOfferDetails.jobAdvertisement),
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
                    companyOfferDetails.jobAdvertisement.description,
                    style: AppTextStyles.hint.copyWith(color: AppColors.darkGrey),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                if (companyOfferDetails.jobAdvertisement.requirement != null)
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
                if (companyOfferDetails.jobAdvertisement.requirement != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      companyOfferDetails.jobAdvertisement.requirement!,
                      style: AppTextStyles.hint.copyWith(color: AppColors.darkGrey),
                    ),
                  ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    context.translate('offers'),
                    style: AppTextStyles.titleBold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                ...companyOfferDetails.employeeOffers
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: EmployeeOfferToCompanyJobCard(
                          employeeOfferToCompany: e,
                          jobToApply: companyOfferDetails.jobAdvertisement.id,
                          provider: null,
                        ),
                      ),
                    )
                    .toList(),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
    );
  }
}
