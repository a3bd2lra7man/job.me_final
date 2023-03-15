import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/widgets/card_loader.dart';
import 'package:job_me/_shared/widgets/shimmer_page.dart';
import 'package:job_me/home/main/providers/general_ads_proivder.dart';
import 'package:job_me/home/main/ui/screens/governments_ad_web_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class GovernmentAdsWidget extends StatelessWidget {
  const GovernmentAdsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<GeneralAdsProvider>();
    return provider.isLoading
        ? const ShimmerEffect(child: CardLoader())
        : provider.generalAds.isEmpty
            ? const SizedBox()
            : CarouselSlider.builder(
                itemCount: provider.generalAds.length,
                itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                  return GestureDetector(
                    onTap: () async {
                      var ad = provider.generalAds[itemIndex];
                      await openBrowser(ad.urlToGo);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.hardEdge,
                      child: Image.network(
                        provider.generalAds[itemIndex].image,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 200,
                  aspectRatio: 16 / 9,
                  viewportFraction: .8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
              );
  }
}
Future<void> openBrowser(String url) async {
  Get.to(() => GovernmentAdScreen(url: url));
}
