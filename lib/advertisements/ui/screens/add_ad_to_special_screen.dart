import 'package:flutter/material.dart';
import 'package:job_me/_job_advertisement_core/models/job_advertisement.dart';
import 'package:job_me/advertisements/providers/ad_to_special_provider.dart';
import 'package:job_me/advertisements/providers/my_ads_provider.dart';
import 'package:job_me/advertisements/ui/widgets/job_header.dart';
import 'package:job_me/advertisements/ui/widgets/transaction_card.dart';
import 'package:job_me/advertisements/ui/widgets/transactions_card_loader.dart';
import 'package:provider/provider.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';

class AddAdToSpecialScreen extends StatefulWidget {
  final JobAdvertisement jobAdvertisement;

  static Widget init(
      {required AdToSpecialProvider? adToSpecialProvider,
      required MyAdsProvider? myAdsProvider,
      required JobAdvertisement jobAdvertisement}) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: myAdsProvider,
          ),
          myAdsProvider != null
              ? ChangeNotifierProvider.value(
                  value: myAdsProvider,
                )
              : ChangeNotifierProvider(create: (context) => MyAdsProvider(context)),
          adToSpecialProvider != null
              ? ChangeNotifierProvider.value(
                  value: adToSpecialProvider,
                )
              : ChangeNotifierProvider(create: (context) => AdToSpecialProvider(context))
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
      context.read<AdToSpecialProvider>().getTransactions();
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
            ? const TransactionsCardLoader()
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 20),
                  JobHeader(
                    job: widget.jobAdvertisement,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.translate('coins_cards'),
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
