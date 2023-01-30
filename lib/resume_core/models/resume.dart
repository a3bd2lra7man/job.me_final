import 'package:job_me/resume_employee/certificates_and_training/models/certificate_or_training.dart';
import 'package:job_me/resume_employee/educations/models/education.dart';
import 'package:job_me/resume_employee/experiences/models/experience.dart';
import 'package:job_me/resume_employee/skills/models/skill.dart';
import 'package:job_me/user/_user_core/models/user.dart';

class Resume {
  late List<Education> educations;

  late List<Experience> experience;
  late List<CertificateOrTraining> certificatesOrTrainings;
  late List<Skill> skills;
  late User userInfo;

  Resume.fromJson(Map map) {
    educations = Education.getListOfEducations(map['Education']);
    experience = Experience.getListOfExperiences(map['Experiences']);
    certificatesOrTrainings = CertificateOrTraining.getListOfCertificatesOrTrainings(map['Certificates']);
    skills = Skill.getListOfSkills(map['Skills']);
    map['user']['token'] = "";
    userInfo = User.fromJson(map['user']);
  }
}
