import 'package:flutter/material.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_utils/check_is_user_logged_in.dart';
import 'package:job_me/home/offers/providers/company_offers_provider.dart';
import 'package:job_me/home/offers/ui/widget/company_offer_card.dart';
import 'package:job_me/home/offers/ui/widget/offers_loader.dart';
import 'package:provider/provider.dart';

class CompanyOffersScreen extends StatefulWidget {
  static Widget init() {
    return ChangeNotifierProvider(
      create: (context) => CompanyOffersProvider(context),
      child: const CompanyOffersScreen._(),
    );
  }

  const CompanyOffersScreen._({Key? key}) : super(key: key);

  @override
  State<CompanyOffersScreen> createState() => _CompanyOffersScreenState();
}

class _CompanyOffersScreenState extends State<CompanyOffersScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (isUserNotLoggedIn(context)) return;
      context.read<CompanyOffersProvider>().getNextOffers();
    });
    _setupScrollDownToLoadMoreItems();
  }

  void _setupScrollDownToLoadMoreItems() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        context.read<CompanyOffersProvider>().getNextOffers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CompanyOffersProvider>();
    return provider.isFirstLoading
        ? const OffersPageLoader()
        : ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const SizedBox(height: 16),
              Column(
                children: provider.offers.map((job) => CompanyOfferCard(offer: job)).toList(),
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
          );
  }
}
