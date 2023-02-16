import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/loading_widget.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/advertisements/providers/advertisement_provider.dart';
import 'package:job_me/advertisements/providers/job_advertisement_form_provider.dart';
import 'package:job_me/advertisements/ui/screens/add_ad_to_special_screen.dart';
import 'package:job_me/advertisements/ui/widgets/job_advertisement_form.dart';
import 'package:job_me/advertisements/ui/widgets/job_advertisement_form_header.dart';
import 'package:provider/provider.dart';

class UpdateJobAdvertisementScreen extends StatefulWidget {
  final JobAdvertisement jobAdvertisement;

  static Widget init(JobAdvertisement jobAdvertisement) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AdvertisementOffersProvider(context)),
        ChangeNotifierProvider(
            create: (context) => JobAdvertisementFormProvider(context)..onStartUpdatingAnAds(jobAdvertisement)),
      ],
      child: UpdateJobAdvertisementScreen._(
        jobAdvertisement: jobAdvertisement,
      ),
    );
  }

  const UpdateJobAdvertisementScreen._({Key? key, required this.jobAdvertisement}) : super(key: key);

  @override
  State<UpdateJobAdvertisementScreen> createState() => _UpdateJobAdvertisementScreenState();
}

class _UpdateJobAdvertisementScreenState extends State<UpdateJobAdvertisementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var provider = context.read<AdvertisementOffersProvider>();
      provider.getRequiredData().then((value) {
        var jobAdvertisementCategory = provider.selectableCategories.firstWhere(
            (element) => element.id == widget.jobAdvertisement.categoryId,
            orElse: () => provider.selectableCategories[0]);
        context.read<JobAdvertisementFormProvider>().setSelectedCategory(jobAdvertisementCategory);
      });
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var formProvider = context.watch<JobAdvertisementFormProvider>();
    var provider = context.watch<AdvertisementOffersProvider>();
    return Scaffold(
      appBar: PrimaryAppBar(
        elevation: 0,
        title: context.translate('promote_my_self'),
        titleColor: AppColors.black,
      ),
      body: Container(
        color: AppColors.primary.withOpacity(.04),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 20),
            const JobAdvertisementFormHeader(),
            const SizedBox(height: 20),
            Text(
              context.translate('job_info'),
              style: AppTextStyles.titleBold,
            ),
            const SizedBox(height: 10),
            provider.isLoading
                ? const LoadingWidget()
                : Builder(builder: (_) {
                    return JobAdvertisementForm(
                      formKey: _formKey,
                    );
                  }),
            const SizedBox(height: 20),
            formProvider.isLoading
                ? const LoadingWidget()
                : provider.isLoading
                    ? const SizedBox()
                    : PrimaryButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            formProvider.updateJobAdvertisement(widget.jobAdvertisement.id);
                          }
                        },
                        title: context.translate('update_ads'),
                      ),
            const SizedBox(height: 20),
            Visibility(
              visible: !widget.jobAdvertisement.isSpecial,
              child: PrimaryButton(
                color: AppColors.white,
                titleColor: AppColors.primary,
                onPressed: () {
                  Get.to(AddAdToSpecialScreen.init(
                      adToSpecialProvider: null, myAdsProvider: null, jobAdvertisement: widget.jobAdvertisement));
                },
                title: context.translate('add_to_special'),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
