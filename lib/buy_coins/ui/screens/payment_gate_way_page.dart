// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentGateWayPage extends StatelessWidget {
  PaymentGateWayPage({Key? key, required String url}) : super(key: key) {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            if (url.contains('accounts/buy-coins')) {
              var strings = url.split("paymentId=");
              var paymentId = strings[1].split('&')[0];
              Get.back(result: paymentId);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  late WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: context.translate('buy_coins'),
      ),
      body: WebViewWidget(
        controller: webViewController,
      ),
    );
  }
}
