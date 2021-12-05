import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_project/services/authentication_helper.dart';

class FirebaseAuthentication {
  FirebaseAuthentication._privateConsrtructor();

  static final FirebaseAuthentication _instance =
      FirebaseAuthentication._privateConsrtructor();
  static FirebaseAuthentication get instance => _instance;

  //DO VERIFY
  Future<void> verifyPhoneNumber(String phoneNum) async {
    phoneNum = '+' + phoneNum;
    await FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: phoneNum,
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    )
        .catchError((e) {
      print('Error at login firebase: $e');
    });
  }

  ///
  ///
  //SUCCESS
  final PhoneVerificationCompleted verificationCompleted =
      (AuthCredential phoneAuthCredential) async {
    await FirebaseAuth.instance
        .signInWithCredential(phoneAuthCredential)
        .then((value) {
      if (value.user != null) {
        print('Success login firebase');
      } else {
        print('FAILED login firebase');
      }
    }).catchError((onError) {
      print('Error Login Firebase: $onError');
    });
  };

  //FAILED
  final PhoneVerificationFailed verificationFailed =
      (Exception authException) async {
    if (authException.toString().contains('too-many-requests')) {
      print('verify failed. Too many request.');
    } else {
      print('other exception when verify: ${authException.toString()}');
    }
  };

  //CODE SENT
  final PhoneCodeSent codeSent =
      (String verificationId, [int? forceResendingToken]) async {
    AuthenticateHelper.instance.updateVerificationId(verificationId);
    print('code sent');
  };
  //TIMEOUT
  final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
      (String verificationId) async {
    AuthenticateHelper.instance.updateVerificationId(verificationId);
    print('time out');
  };

  //DO SIGN IN
  Future<SignInMessage> confirmPhoneNumber(String otp) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: AuthenticateHelper.instance.getVerificationId(),
      smsCode: otp,
    );
    SignInMessage msg = SignInMessage.INITIAL;
    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((userCredential) {
      if (userCredential.user != null) {
        msg = SignInMessage.SUCCESS;
      } else {
        msg = SignInMessage.ERROR_SIGN_IN;
      }
    }).onError((e, stackTrace) {
      print('ERROR at sign in with phone number: $e');
      if (e.toString().contains('expired')) {
        print('OTP code time out or wrong OTP code');
        msg = SignInMessage.WRONG_OTP;
      } else {
        msg = SignInMessage.ERROR_SIGN_IN;
      }
    });
    return msg;
  }
}

enum SignInMessage {
  INITIAL,
  SUCCESS,
  WRONG_OTP,
  ERROR_SIGN_IN,
}

enum OTPSendMessage {
  INITIAL,
  SUCCESS,
  NOT_FOUND_USER_SIGN_IN,
  CATCH_ERROR_SIGN_IN_WITH_CREDENTIAL,
  MANY_REQUESTS,
  OTHER_EXCEPTION,
  CODE_SENT,
  TIME_OUT,
  VERIFY_FAILED,
}
