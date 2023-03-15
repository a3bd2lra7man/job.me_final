import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/advertisement_core/proivders/my_ads_provider.dart';
import 'package:job_me/advertisement_special/ui/widgets/prepare_to_be_special_my_ads_card.dart';
import 'package:job_me/advertisement_special/ui/widgets/prepare_to_special_my_ads_loader.dart';
import 'package:provider/provider.dart';

class PrepareMyAdvertisementToSpecialScreen extends StatefulWidget {
  static Widget init() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyAdsProvider(context)),
      ],
      child: const PrepareMyAdvertisementToSpecialScreen._(),
    );
  }

  const PrepareMyAdvertisementToSpecialScreen._({Key? key}) : super(key: key);

  @override
  State<PrepareMyAdvertisementToSpecialScreen> createState() => _PrepareMyAdvertisementToSpecialScreenState();
}

class _PrepareMyAdvertisementToSpecialScreenState extends State<PrepareMyAdvertisementToSpecialScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<MyAdsProvider>().getCategories().then((value) => context.read<MyAdsProvider>().getNextMyAds());
    });
    _setupScrollDownToLoadMoreItems();
  }

  void _setupScrollDownToLoadMoreItems() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        context.read<MyAdsProvider>().getNextMyAds();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<MyAdsProvider>();
    return Scaffold(
      appBar: PrimaryAppBar(
        elevation: 0,
        title: context.translate('my_ads'),
        titleColor: AppColors.black,
      ),
      body: Container(
        color: AppColors.primary.withOpacity(.04),
        child: provider.isFirstLoading
            ? const PrepareToSpecialMyAdsLoader()
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 16),
                  Text(
                    context.translate('choose_ad_to_ad_to_special'),
                    style: AppTextStyles.titleBold,
                  ),
                  provider.myAds.isEmpty
                      ? Text(
                          context.translate('please_ad_an_ad_first'),
                          style: AppTextStyles.headerBig.copyWith(color: AppColors.primary),
                          textAlign: TextAlign.center,
                        )
                      : Column(
                          children: provider.myAds.map((job) => PrepareToBeSpecialMyAdsCard(job: job)).toList(),
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
              ),
      ),
    );
  }
}
