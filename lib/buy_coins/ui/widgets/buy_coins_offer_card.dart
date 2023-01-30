import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/loading_widget.dart';
import 'package:job_me/buy_coins/models/buy_coins_offer.dart';
import 'package:job_me/buy_coins/providers/coins_provider.dart';
import 'package:job_me/buy_coins/ui/screens/payment_gate_way_page.dart';
import 'package:job_me/main.dart';
import 'package:provider/provider.dart';

class BuyCoinsCard extends StatefulWidget {
  final BuyCoinsOffer offer;

  const BuyCoinsCard({
    Key? key,
    required this.offer,
  }) : super(key: key);

  @override
  State<BuyCoinsCard> createState() => _BuyCoinsCardState();
}

class _BuyCoinsCardState extends State<BuyCoinsCard> with RouteAware {
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CoinsProvider>();
    return GestureDetector(
      onTap: () async {
        setState(() {
          isLoading = true;
        });
        var url = await provider.generateBuyUrl(widget.offer);
        if (url != null) {
          var paymentId = await Get.to(() => PaymentGateWayPage(url: url));
          if (paymentId != null) {
            provider.checkPaymentStatus(paymentId, widget.offer.name);
          }
        }
        setState(() {
          isLoading = false;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Card(
          margin: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: ListTile(
              title: Text(
                widget.offer.description,
                style: AppTextStyles.bodyMedium,
              ),
              trailing: isLoading
                  ? const LoadingWidget()
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              widget.offer.name,
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, height: 1.4),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${widget.offer.price} \$",
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, height: 1.4),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
              leading: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.3),
                ),
                child: Image.asset(
                  "assets/images/img_6.png",
                  width: 64,
                  height: 64,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
