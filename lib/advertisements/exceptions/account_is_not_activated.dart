import 'package:job_me/_shared/exceptions/app_exception.dart';

class AccountIsNotActivated extends AppException{
  AccountIsNotActivated():super("please_activate_your_account","");
}