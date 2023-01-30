import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/user/account_verification/exception/code_verification_failed.dart';
import 'package:job_me/user/account_verification/exception/phone_verification_failed.dart';

class PhoneNumberVerifier {
  PhoneNumberVerifier._();

  static final PhoneNumberVerifier instance = PhoneNumberVerifier._();

  factory PhoneNumberVerifier() => instance;

  int? _forceResendingToken;
  String? _verificationId;

  Future sendCodeToPhoneNumber(
    BuildContext context,
    String userNumber, {
    required Function codeSent,
    required Function(AppException) onFailed,
  }) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      forceResendingToken: _forceResendingToken,
      phoneNumber: userNumber,
      verificationCompleted: (phonesAuthCredentials) {
        codeSent();
      },
      verificationFailed: (verificationFailed) {
        onFailed(PhoneVerificationField());
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        _verificationId = verificationId;
        _forceResendingToken = forceResendingToken;
        codeSent();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future assertCodeIsRight(
    BuildContext context,
    String code, {
    required Function onSuccess,
    required Function(AppException) onFailed,
  }) async {
    var credential = PhoneAuthProvider.credential(verificationId: _verificationId ?? "", smsCode: code);
    await FirebaseAuth.instance.signInWithCredential(credential).then((UserCredential value) async {
      onSuccess();
    }).onError((error, stackTrace) {
      onFailed(CodeVerificationField());
    });
  }
}
