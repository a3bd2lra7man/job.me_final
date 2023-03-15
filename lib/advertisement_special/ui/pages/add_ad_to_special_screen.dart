import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/advertisement_special/providers/ad_to_special_provider.dart';
import 'package:job_me/advertisement_core/proivders/my_ads_provider.dart';
import 'package:job_me/advertisement_special/ui/widgets/advertisement_job_card.dart';
import 'package:job_me/advertisement_special/ui/widgets/transaction_card.dart';
import 'package:job_me/advertisement_special/ui/widgets/transactions_card_loader.dart';
import 'package:provider/provider.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';

class AddAdToSpecialScreen extends StatefulWidget {
  final JobAdvertisement jobAdvertisement;

  static Widget init({required JobAdvertisement jobAdvertisement}) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MyAdsProvider(context)),
          ChangeNotifierProvider(create: (context) => AdToSpecialProvider(context))
        ],
        child: AddAdToSpecialScreen._(
          jobAdvertisement: jobAdvertisement,
        ));
  }

  const AddAdToSpecialScreen._({Key? key, required this.jobAdvertisement}) : super(key: key);

  @override
  State<AddAdToSpecialScreen> createState() => _AddAdToSpecialScreenState();
}

class _AddAdToSpecialScreenState extends State<AddAdToSpecialScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AdToSpecialProvider>().getBoughtCoins();
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<AdToSpecialProvider>();
    return Scaffold(
      appBar: PrimaryAppBar(
        elevation: 0,
        title: context.translate('add_to_special'),
        titleColor: AppColors.black,
      ),
      body: Container(
        color: AppColors.primary.withOpacity(.04),
        child: provider.isLoading
            ? const AdToSpecialLoader()
            : provider.transactions.isEmpty
                ? SizedBox(
                    height: context.height,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          context.translate('you_did_not_buy_any_coins'),
                          style: AppTextStyles.headerBig.copyWith(color: AppColors.primary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      const SizedBox(height: 20),
                      AdvertisementJobCard(
                        job: widget.jobAdvertisement,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        context.translate('pick_active_coins_cards'),
                        style: AppTextStyles.titleBold,
                      ),
                      ...(provider.transactions
                          .map((transaction) => TransactionCard(
                                transaction: transaction,
                                jobAdvertisement: widget.jobAdvertisement,
                              ))
                          .toList()),
                    ],
                  ),
      ),
    );
  }
}
