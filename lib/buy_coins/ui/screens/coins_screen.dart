import 'package:flutter/material.dart';
import 'package:job_me/buy_coins/ui/widgets/buy_coins_header.dart';
import 'package:job_me/buy_coins/ui/widgets/buy_coins_offer_card.dart';
import 'package:job_me/buy_coins/ui/widgets/buy_coins_offer_cards_loader.dart';
import 'package:provider/provider.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/buy_coins/providers/coins_provider.dart';

class CoinsScreen extends StatefulWidget {
  static Widget init() {
    return ChangeNotifierProvider(create: (context) => CoinsProvider(context), child: const CoinsScreen._());
  }

  const CoinsScreen._({Key? key}) : super(key: key);

  @override
  State<CoinsScreen> createState() => _CoinsScreenState();
}

class _CoinsScreenState extends State<CoinsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CoinsProvider>().getUserBalanceAndBuyCoinsOffer();
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CoinsProvider>();
    return Scaffold(
      appBar: PrimaryAppBar(
        elevation: 0,
        title: context.translate('buy_credit'),
        titleColor: AppColors.black,
      ),
      body: Container(
        color: AppColors.primary.withOpacity(.04),
        child: provider.isLoading
            ? const BuyCoinsOfferCardLoader()
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 20),
                  BuyCoinsHeader(provider: provider),
                  const SizedBox(height: 20),
                  Text(
                    context.translate('coins_cards'),
                    style: AppTextStyles.titleBold,
                  ),
                  ...(provider.buyCoinsModel?.offers.map((offer) => BuyCoinsCard(offer: offer)).toList() ?? []),
                ],
              ),
      ),
    );
  }
}
