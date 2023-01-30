import 'package:job_me/_shared/api/entities/image_file.dart';

class CompanyInfoFormData {
  late String name;
  String size;
  String date;
  String notes;
  String field;
  String email;
  ImageFile? photoFile;

  CompanyInfoFormData({
    required this.name,
    required this.date,
    required this.field,
    required this.size,
    required this.notes,
    required this.email,
    required this.photoFile
  });

  Map<String, dynamic> toJson() =>
      {
        'fullname': name,
        'size': size,
        'employment': field,
        'notes': notes,
        'date': date,
        'email':email,
      };
}
