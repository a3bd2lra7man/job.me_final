import 'package:job_me/_shared/exceptions/app_exception.dart';

class CodeVerificationField extends AppException {
  CodeVerificationField() : super("code_verification_failed", "");
}
