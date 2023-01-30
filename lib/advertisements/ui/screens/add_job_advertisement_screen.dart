import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/loading_widget.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/advertisements/providers/advertisement_provider.dart';
import 'package:job_me/advertisements/providers/job_advertisement_form_provider.dart';
import 'package:job_me/advertisements/ui/widgets/job_advertisement_form.dart';
import 'package:job_me/advertisements/ui/widgets/job_advertisement_form_header.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';
import 'package:provider/provider.dart';

class AddJobAdvertisementScreen extends StatefulWidget {
  static Widget init() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AdvertisementOffersProvider(context)),
        ChangeNotifierProvider(create: (context) => JobAdvertisementFormProvider(context)),
      ],
      child: const AddJobAdvertisementScreen._(),
    );
  }

  const AddJobAdvertisementScreen._({Key? key}) : super(key: key);

  @override
  State<AddJobAdvertisementScreen> createState() => _AddJobAdvertisementScreenState();
}

class _AddJobAdvertisementScreenState extends State<AddJobAdvertisementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AdvertisementOffersProvider>().getAdvertisementData();
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<JobAdvertisementFormProvider>();
    return Scaffold(
      appBar: PrimaryAppBar(
        elevation: 0,
        title: _getAppropriateTitleForEachUser(),
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
            JobAdvertisementForm(
              formKey: _formKey,
            ),
            const SizedBox(height: 20),
            provider.isLoading
                ? const LoadingWidget()
                : PrimaryButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        provider.addJobAdvertisement();
                      }
                    },
                    title: _getAppropriateTextForEachUser(),
                  ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  _getAppropriateTextForEachUser() {
    var userRepo = UserRepository();
    if (userRepo.isEmployee()) {
      return context.translate('advertise');
    } else {
      return context.translate('promote_a_job_position');
    }
  }

  _getAppropriateTitleForEachUser() {
    var userRepo = UserRepository();
    if (userRepo.isEmployee()) {
      return context.translate('promote_my_self');
    } else {
      return context.translate('promote_a_job_position');
    }
  }
}
