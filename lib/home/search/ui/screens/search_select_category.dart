import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/_utils/localizations/localization_proivder.dart';
import 'package:job_me/home/search/providers/search_provider.dart';
import 'package:provider/provider.dart';

class SearchSelectCategory extends StatefulWidget {
  static init(SearchJobsProvider provider) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: const SearchSelectCategory._(),
    );
  }

  const SearchSelectCategory._({Key? key}) : super(key: key);

  @override
  _SearchSelectCategoryState createState() => _SearchSelectCategoryState();
}

class _SearchSelectCategoryState extends State<SearchSelectCategory> {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<SearchJobsProvider>();
    var isEnglish = context.watch<LocalizationProvider>().isEn();
    return Scaffold(
      appBar: PrimaryAppBar(
        title: context.translate('category_selection'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () {
              provider.setSelectedCategory(null);
              Get.back();
            },
            leading: Icon(
              provider.selectedCategory == null ? Icons.radio_button_checked : Icons.radio_button_off_outlined,
              color: AppColors.primary,
            ),
            title: Text(context.translate('all_search_category')),
          ),
          ...provider.selectableCategories
              .map(
                (category) => ListTile(
                  onTap: () {
                    provider.setSelectedCategory(category);
                    Get.back();
                  },
                  leading: Icon(
                    provider.selectedCategory == category
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off_outlined,
                    color: AppColors.primary,
                  ),
                  title: Text(category.getName(isEnglish)),
                ),
              )
              .toList()
        ],
      ),
    );
  }
}
