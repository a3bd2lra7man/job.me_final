import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/advertisement_core/proivders/my_ads_provider.dart';
import 'package:job_me/advertisements/ui/widgets/my_ads_card.dart';
import 'package:job_me/advertisements/ui/widgets/my_ads_loader.dart';
import 'package:provider/provider.dart';

class MyAdvertisementScreen extends StatefulWidget {
  static Widget init() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyAdsProvider(context)),
      ],
      child: const MyAdvertisementScreen._(),
    );
  }

  const MyAdvertisementScreen._({Key? key}) : super(key: key);

  @override
  State<MyAdvertisementScreen> createState() => _MyAdvertisementScreenState();
}

class _MyAdvertisementScreenState extends State<MyAdvertisementScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<MyAdsProvider>().getCategories().then((value) =>
          context.read<MyAdsProvider>().getNextMyAds()
      );
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
            ? const MyAdsLoader()
            : ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 16),
            Column(
              children: provider.myAds.map((job) => MyAdsCard(job: job)).toList(),
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
