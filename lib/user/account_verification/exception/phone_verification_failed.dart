import 'package:job_me/_shared/exceptions/app_exception.dart';

class PhoneVerificationField extends AppException {
  PhoneVerificationField() : super("phone_verification_failed", "");
}
