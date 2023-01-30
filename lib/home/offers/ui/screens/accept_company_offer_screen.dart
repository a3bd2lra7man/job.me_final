// import 'package:flutter/material.dart';
// import 'package:job_me/_shared/extensions/context_extensions.dart';
// import 'package:job_me/_shared/themes/colors.dart';
// import 'package:job_me/_shared/themes/text_styles.dart';
// import 'package:job_me/_shared/widgets/loading_widget.dart';
// import 'package:job_me/_shared/widgets/primary_app_bar.dart';
// import 'package:job_me/home/job_details/providers/job_details_provider.dart';
// import 'package:job_me/home/job_details/ui/screens/job_details_screen_loader.dart';
// import 'package:job_me/home/job_details/ui/widgets/job_details_header.dart';
// import 'package:job_me/home/offers/models/employee_offer.dart';
// import 'package:provider/provider.dart';
//
// class AcceptCompanyOfferScreen extends StatefulWidget {
//   final EmployeeOffer offer;
//
//   static Widget init({required EmployeeOffer offer}) {
//     return ChangeNotifierProvider(
//         create: (context) => JobDetailsProvider(context: context, jobId: offer.jobId),
//         child: AcceptCompanyOfferScreen._(offer: offer));
//   }
//
//   const AcceptCompanyOfferScreen._({Key? key, required this.offer}) : super(key: key);
//
//   @override
//   State<AcceptCompanyOfferScreen> createState() => _AcceptCompanyOfferScreenState();
// }
//
// class _AcceptCompanyOfferScreenState extends State<AcceptCompanyOfferScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       context.read<JobDetailsProvider>().getJobDetails();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var provider = context.watch<JobDetailsProvider>();
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar: PrimaryAppBar(
//         elevation: 0,
//         title: context.translate('accept_offer'),
//         titleColor: AppColors.black,
//         actions: _getActionButton(provider),
//       ),
//       body: provider.isLoading
//           ? const JobDetailsScreenLoader()
//           : Builder(
//               builder: (context) => ListView(
//                 children: [
//                   const SizedBox(
//                     height: 40,
//                   ),
//                   JobDetailsHeader(job: provider.job),
//                   const SizedBox(
//                     height: 40,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 40),
//                     child: Text(
//                       context.translate('job_description'),
//                       style: AppTextStyles.titleBold,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 40),
//                     child: Text(
//                       provider.job.description,
//                       style: AppTextStyles.hint.copyWith(color: AppColors.darkGrey),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 32,
//                   ),
//                   if (provider.job.requirement != null)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 40),
//                       child: Text(
//                         context.translate('job_requirements'),
//                         style: AppTextStyles.titleBold,
//                       ),
//                     ),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   if (provider.job.requirement != null)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 40),
//                       child: Text(
//                         provider.job.requirement!,
//                         style: AppTextStyles.hint.copyWith(color: AppColors.darkGrey),
//                       ),
//                     ),
//                   const SizedBox(
//                     height: 40,
//                   ),
//                   provider.isTransactionLoading
//                       ? const LoadingWidget()
//                       : Column(
//                           children: [
//                             // _getApplyButton(),
//                           ],
//                         ),
//                   const SizedBox(
//                     height: 40,
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
//
//   List<Widget>? _getActionButton(JobDetailsProvider provider) {
//     if (provider.isLoading) return null;
//     var icon = provider.job.isSaved ? Icons.bookmark : Icons.bookmark_border;
//     var onPressed = provider.job.isSaved ? provider.removeJobFromSavedList : provider.addJobToSavedList;
//     return [
//       IconButton(
//         onPressed: onPressed,
//         icon: Icon(icon, color: AppColors.black),
//       ),
//     ];
//   }
//
//   // Widget _getApplyButton() {
//   //   var offersProvider = context.watch<EmployeeOffersProvider>();
//   //   var text = widget.offer.isAccepted() ? 'cancel_offer' : 'accept_offer';
//   //   var onPressed = widget.offer.isAccepted()
//   //       ? () => offersProvider.cancelOffer(widget.offer.jobId)
//   //       : () => offersProvider.acceptOffer(widget.offer.jobId);
//   //   return Padding(
//   //     padding: const EdgeInsets.symmetric(horizontal: 40),
//   //     child: PrimaryButton(
//   //       onPressed: onPressed,
//   //       title: text,
//   //     ),
//   //   );
//   // }
// }
