import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/home/_shared/widgets/home_app_bar.dart';
import 'package:job_me/home/account/ui/screens/account_page.dart';
import 'package:job_me/home/home/providers/home_provider.dart';
import 'package:job_me/home/home/ui/widgets/basic_home_bottom_navigation_bar.dart';
import 'package:job_me/home/main/ui/screens/main_page.dart';
import 'package:job_me/home/offers/ui/screens/offers_page.dart';
import 'package:job_me/home/saved_jobs/ui/screens/saved_ads_jobs_page.dart';
import 'package:job_me/home/search/ui/screens/search_screens.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static Widget init() {
    return ChangeNotifierProvider(
      create: (_) => HomePageProvider(),
      child: const HomePage._(),
    );
  }

  const HomePage._({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<HomePageProvider>();
    return Scaffold(
      appBar: provider.selectedPage == HomePages.account ? null : const HomeAppBar(),
      bottomNavigationBar: SizedBox(
        height: 90,
        child: BasicHomeBottomNavigationBar(color: AppColors.primary),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => SearchScreen.init(provider), transition: Transition.downToUp),
        child: Container(
          decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
          child: Container(
            decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            width: 64,
            height: 64,
            child: Icon(
              Icons.search,
              size: 40,
              color: AppColors.white,
            ),
          ),
        ),
      ),
      body: _getBody(provider),
    );
  }

  Widget _getBody(HomePageProvider provider) {
    switch (provider.selectedPage) {
      case HomePages.saved:
        return SavedAdsJobsScreen.init();
      case HomePages.main:
        return MainPage();
      case HomePages.offers:
        return OffersScreen();
      case HomePages.account:
        return AccountPage.init();
    }
  }
}
