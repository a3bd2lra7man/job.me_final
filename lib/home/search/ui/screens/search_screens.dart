import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/_shared/widgets/primary_button.dart';
import 'package:job_me/_shared/widgets/primary_edit_text.dart';
import 'package:job_me/home/_shared/widgets/job_card.dart';
import 'package:job_me/home/home/providers/home_provider.dart';
import 'package:job_me/home/search/providers/search_provider.dart';
import 'package:job_me/home/search/ui/widgets/saved_jobs_loader.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static Widget init(HomePageProvider provider) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: ChangeNotifierProvider(
        create: (context) => SearchJobsProvider(context),
        child: const SearchScreen._(),
      ),
    );
  }

  const SearchScreen._({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _setupScrollDownToLoadMoreItems();
  }

  void _setupScrollDownToLoadMoreItems() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        context.read<SearchJobsProvider>().getNextSearchedJobs();
      }
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<SearchJobsProvider>();
    return Scaffold(
      appBar: PrimaryAppBar(
        title: context.translate('the_search'),
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: PrimaryButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) provider.searchedJobs();
        },
        title: context.translate('search'),
      ),
      body: Container(
        color: AppColors.primary.withOpacity(.04),
        child: ListView(
          controller: _scrollController,
          children: [
            Form(
              key: _formKey,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: PrimaryEditText(
                        validator: (s) =>
                            s != null && s.isNotEmpty ? null : context.translate('please_enter_valid_string'),
                        hint: context.translate('write_job_name'),
                        controller: provider.searchController,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) provider.searchedJobs();
                          },
                          child: Icon(
                            Icons.search,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            provider.isFirstLoading
                ? const SearchJobsPageLoader()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: provider.resultJobs.map((job) => JobCard(job: job)).toList(),
                    ),
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
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
