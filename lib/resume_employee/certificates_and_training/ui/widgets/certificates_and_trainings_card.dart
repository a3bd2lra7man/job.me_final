import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/resume_employee/certificates_and_training/providers/certificates_and_training_provider.dart';
import 'package:job_me/resume_employee/certificates_and_training/ui/screens/add_certificates_and_trainings_screen.dart';
import 'package:job_me/resume_employee/certificates_and_training/ui/screens/update_certificates_and_trainings_screen.dart';
import 'package:job_me/resume_employee/resume/providers/resume_provider.dart';
import 'package:job_me/resume_core/ui/widgets/resume_container.dart';
import 'package:job_me/resume_core/ui/widgets/resume_container_loader.dart';
import 'package:job_me/resume_core/ui/widgets/row_tile.dart';
import 'package:provider/provider.dart';

class CertificatesAndTrainingsCard extends StatelessWidget {
  static Widget init() {
    return ChangeNotifierProvider(
      create: (context) => CertificatesAndTrainingsProvider(context),
      child: const CertificatesAndTrainingsCard._(),
    );
  }

  const CertificatesAndTrainingsCard._({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var resumeProvider = context.watch<ResumeProvider>();
    var certificatesAndTrainingsProvider = context.watch<CertificatesAndTrainingsProvider>();
    return resumeProvider.isLoading || certificatesAndTrainingsProvider.isLoading
        ? const ResumeContainerLoader()
        : Builder(builder: (context) {
            return ResumeContainer(
              title: context.translate('certificates_and_trainings'),
              iconData: Icons.add_box_rounded,
              buttonText: context.translate('add_certificates_or_trainings'),
              onButtonClicked: () {
                Get.to(AddCertificatesAndTrainingsScreen.init(
                    resumeProvider: resumeProvider,
                    certificatesAndTrainingsProvider: certificatesAndTrainingsProvider));
              },
              children: [
                ...resumeProvider.resume.certificatesOrTrainings
                    .map(
                      (certificatesOrTraining) => Column(
                        children: [
                          const SizedBox(height: 16),
                          RowTile(title: context.translate('certificate_name'), subTitle: certificatesOrTraining.name),
                          RowTile(
                              title: context.translate('certificate_provider_name'),
                              subTitle: certificatesOrTraining.providerName),
                          RowTile(title: context.translate('field'), subTitle: certificatesOrTraining.field),
                          RowTile(title: context.translate('date'), subTitle: certificatesOrTraining.date),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(UpdateCertificatesAndTrainingsScreen.init(
                                    resumeProvider: resumeProvider,
                                    certificateOrTraining: certificatesOrTraining,
                                    certificatesAndTrainingsProvider: certificatesAndTrainingsProvider,
                                  ));
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.edit_road_sharp,
                                      color: AppColors.primary,
                                    ),
                                    Text(
                                      context.translate('edit'),
                                      style: AppTextStyles.smallStyle.copyWith(color: AppColors.primary),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await certificatesAndTrainingsProvider
                                      .deleteCertificateOrTraining(certificatesOrTraining.id!);
                                  await resumeProvider.fetchResume();
                                },
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      context.translate('delete'),
                                      style: AppTextStyles.smallStyle.copyWith(color: Colors.red),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: AppColors.lightGrey,
                          ),
                        ],
                      ),
                    )
                    .toList()
              ],
            );
          });
  }
}
