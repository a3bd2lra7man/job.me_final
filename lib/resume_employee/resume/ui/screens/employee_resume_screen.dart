import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/resume_employee/certificates_and_training/ui/widgets/certificates_and_trainings_card.dart';
import 'package:job_me/resume_employee/educations/ui/widgets/educations_card.dart';
import 'package:job_me/resume_employee/experiences/ui/widgets/experiences_card.dart';
import 'package:job_me/resume_employee/personal_info/ui/widgets/personal_info_card.dart';
import 'package:job_me/resume_employee/resume/providers/resume_provider.dart';
import 'package:job_me/resume_employee/skills/ui/widgets/skills_card.dart';
import 'package:provider/provider.dart';

class EmployeeResumeScreen extends StatefulWidget {
  static Widget init() {
    return ChangeNotifierProvider(
      create: (context) => ResumeProvider(context),
      child: const EmployeeResumeScreen._(),
    );
  }

  const EmployeeResumeScreen._({Key? key}) : super(key: key);

  @override
  State<EmployeeResumeScreen> createState() => _EmployeeResumeScreenState();
}

class _EmployeeResumeScreenState extends State<EmployeeResumeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ResumeProvider>().fetchResume();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: context.translate('resume'),
        elevation: 0,
        titleColor: AppColors.black,
      ),
      body: Container(
        color: AppColors.primary.withOpacity(.04),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            PersonalInfoCard.init(),
            const SizedBox(height: 20),
            EducationsCard.init(),
            const SizedBox(height: 20),
            ExperiencesCard.init(),
            const SizedBox(height: 20),
            CertificatesAndTrainingsCard.init(),
            const SizedBox(height: 20),
            SkillsCard.init()
          ],
        ),
      ),
    );
  }
}
