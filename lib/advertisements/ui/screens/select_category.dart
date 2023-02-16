import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/_utils/localizations/localization_proivder.dart';
import 'package:job_me/advertisements/providers/job_advertisement_form_provider.dart';
import 'package:provider/provider.dart';

import '../../models/category.dart';

class SelectCategory extends StatefulWidget {
  final List<Category> categories;

  static init(List<Category> categories, JobAdvertisementFormProvider formProvider) {
    return ChangeNotifierProvider.value(
      value: formProvider,
      child: SelectCategory._(
        categories: categories,
      ),
    );
  }

  const SelectCategory._({Key? key, required this.categories}) : super(key: key);

  @override
  _SelectCategoryState createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<JobAdvertisementFormProvider>();
    var isEnglish = context.watch<LocalizationProvider>().isEn();
    return Scaffold(
      appBar: PrimaryAppBar(
        title: context.translate('category_selection'),
        elevation: 0,
      ),
      body: ListView(
          children: widget.categories
              .map(
                (category) => ListTile(
                  onTap: () => provider.setSelectedCategory(category),
                  leading: Icon(
                    provider.selectedCategory?.id == category.id
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off_outlined,
                    color: AppColors.primary,
                  ),
                  title: Text(category.getName(isEnglish)),
                ),
              )
              .toList()),
    );
  }
}
