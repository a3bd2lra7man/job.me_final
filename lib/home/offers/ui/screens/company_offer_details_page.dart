import 'package:flutter/material.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/home/job_details/ui/screens/job_details_screen_loader.dart';
import 'package:job_me/home/offers/providers/company_offers_details_provider.dart';
import 'package:job_me/home/offers/ui/widget/company_job_details_header.dart';
import 'package:job_me/home/offers/ui/widget/employee_offer_to_company_job_card.dart';
import 'package:provider/provider.dart';

class CompanyOfferDetailsScreen extends StatefulWidget {
  final JobAdvertisement jobAdvertisement;

  static Widget init(JobAdvertisement jobAdvertisement) {
    return ChangeNotifierProvider(
      create: (context) => CompanyOffersDetailsProvider(context),
      child: CompanyOfferDetailsScreen._(
        jobAdvertisement: jobAdvertisement,
      ),
    );
  }

  const CompanyOfferDetailsScreen._({Key? key, required this.jobAdvertisement}) : super(key: key);

  @override
  State<CompanyOfferDetailsScreen> createState() => _CompanyOfferDetailsScreenState();
}

class _CompanyOfferDetailsScreenState extends State<CompanyOfferDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CompanyOffersDetailsProvider>().getOfferDetails(widget.jobAdvertisement.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CompanyOffersDetailsProvider>();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PrimaryAppBar(
        elevation: 0,
        title: context.translate('job_details'),
        titleColor: AppColors.black,
      ),
      body: provider.isLoading || provider.offer == null
          ? const JobDetailsScreenLoader()
          : ListView(
              children: [
                const SizedBox(
                  height: 40,
                ),
                CompanyJobDetailsHeader(job: widget.jobAdvertisement),
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
                    widget.jobAdvertisement.description,
                    style: AppTextStyles.hint.copyWith(color: AppColors.darkGrey),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                if (widget.jobAdvertisement.requirement != null)
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
                if (widget.jobAdvertisement.requirement != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      widget.jobAdvertisement.requirement!,
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
                ...provider.offer!.employeeOffers
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: EmployeeOfferToCompanyJobCard(
                          employeeOfferToCompany: e,
                          jobToApply: widget.jobAdvertisement.id,
                          provider: provider,
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
