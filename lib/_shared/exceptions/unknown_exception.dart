import 'package:job_me/_shared/exceptions/app_exception.dart';

class UnknownException extends AppException {
  UnknownException() : super("unknown_error", "");
}
