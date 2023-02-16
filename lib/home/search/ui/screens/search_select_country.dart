import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/home/search/providers/search_provider.dart';
import 'package:provider/provider.dart';

class SearchSelectCountry extends StatefulWidget {
  static init(SearchJobsProvider provider) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: const SearchSelectCountry._(),
    );
  }

  const SearchSelectCountry._({Key? key}) : super(key: key);

  @override
  _SearchSelectCountryState createState() => _SearchSelectCountryState();
}

class _SearchSelectCountryState extends State<SearchSelectCountry> {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<SearchJobsProvider>();
    return Scaffold(
      appBar: PrimaryAppBar(
        title: context.translate('country_selection'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () {
              provider.setSelectedCountry(null);
              Get.back();
            },
            leading: Icon(
              provider.selectedCountry == null ? Icons.radio_button_checked : Icons.radio_button_off_outlined,
              color: AppColors.primary,
            ),
            title: Text(context.translate('all_countries')),
          ),
          ...provider.selectableCountries
              .map(
                (country) => ListTile(
                  onTap: () {
                    provider.setSelectedCountry(country);
                    Get.back();
                  },
                  leading: Icon(
                    provider.selectedCountry == country ? Icons.radio_button_checked : Icons.radio_button_off_outlined,
                    color: AppColors.primary,
                  ),
                  title: Text(country),
                ),
              )
              .toList()
        ],
      ),
    );
  }
}
