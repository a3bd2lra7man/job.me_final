import 'package:job_me/_shared/exceptions/app_exception.dart';

class UnknownRole extends AppException{
  UnknownRole():super('unknown_error', "This exception happens when user with higher role in the system try to login in the mobile app");
}