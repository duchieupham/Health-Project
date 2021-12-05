import 'package:health_project/main.dart';

class AuthenticateHelper {
  const AuthenticateHelper._privateConsrtructor();

  static final AuthenticateHelper _instance =
      AuthenticateHelper._privateConsrtructor();
  static AuthenticateHelper get instance => _instance;

  void innitalAuthentication() {
    sharedPrefs.setBool('AUTHENTICATION', false);
    sharedPrefs.setInt('ACCOUNT_ID', 0);
    sharedPrefs.setString('TOKEN_ACCOUNT', '');
    sharedPrefs.setString('FIRST_NAME', '');
    sharedPrefs.setString('LAST_NAME', '');
    sharedPrefs.setString('AVATAR', '');
    sharedPrefs.setString('VERIFICATION_ID', '');
  }

  //
  void updateVerificationId(String id) {
    if (!sharedPrefs.containsKey('VERIFICATION_ID') ||
        sharedPrefs.getString('VERIFICATION_ID') == null) {
      innitalAuthentication();
    }
    sharedPrefs.setString('VERIFICATION_ID', id);
  }

  //
  void updateAuthentication({
    required bool isAuthen,
    required int accountId,
    required String tokenAccount,
    required String firstName,
    required String lastName,
    required String avatar,
  }) {
    if (!sharedPrefs.containsKey('AUTHENTICATION') ||
        sharedPrefs.getBool('AUTHENTICATION') == null) {
      innitalAuthentication();
    }
    sharedPrefs.setBool('AUTHENTICATION', isAuthen);
    sharedPrefs.setInt('ACCOUNT_ID', accountId);
    sharedPrefs.setString('TOKEN_ACCOUNT', tokenAccount);
    sharedPrefs.setString('FIRST_NAME', firstName);
    sharedPrefs.setString('LAST_NAME', lastName);
    sharedPrefs.setString('AVATAR', avatar);
  }

  void updateFullname(String firstname, String lastname) {
    if (!sharedPrefs.containsKey('FIRST_NAME') ||
        sharedPrefs.getString('FIRST_NAME') == null) {
      innitalAuthentication();
    }
    sharedPrefs.setString('FIRST_NAME', firstname);
    sharedPrefs.setString('LAST_NAME', lastname);
  }

  void updateAvatar(String avatar) {
    if (!sharedPrefs.containsKey('AVATAR') ||
        sharedPrefs.getString('AVATAR') == null) {
      innitalAuthentication();
    }
    sharedPrefs.setString('AVATAR', avatar);
  }

  String getVerificationId() {
    if (!sharedPrefs.containsKey('VERIFICATION_ID') ||
        sharedPrefs.getString('VERIFICATION_ID') == null) {
      innitalAuthentication();
    }
    return sharedPrefs.getString('VERIFICATION_ID')!;
  }

  String getAvatar() {
    if (!sharedPrefs.containsKey('AVATAR') ||
        sharedPrefs.getString('AVATAR') == null) {
      innitalAuthentication();
    }
    return sharedPrefs.getString('AVATAR')!;
  }

  //
  bool isAuthenticated() {
    if (!sharedPrefs.containsKey('AUTHENTICATION') ||
        sharedPrefs.getBool('AUTHENTICATION') == null) {
      innitalAuthentication();
    }
    return sharedPrefs.getBool('AUTHENTICATION')!;
  }

  //
  int getAccountId() {
    if (!sharedPrefs.containsKey('ACCOUNT_ID') ||
        sharedPrefs.getInt('ACCOUNT_ID') == null) {
      innitalAuthentication();
    }
    return sharedPrefs.getInt('ACCOUNT_ID')!;
  }

  //
  String getTokenAccount() {
    if (!sharedPrefs.containsKey('TOKEN_ACCOUNT') ||
        sharedPrefs.getString('TOKEN_ACCOUNT') == null) {
      innitalAuthentication();
    }
    return sharedPrefs.getString('TOKEN_ACCOUNT')!;
  }

  String getFirstName() {
    if (!sharedPrefs.containsKey('FIRST_NAME') ||
        sharedPrefs.getString('FIRST_NAME') == null) {
      innitalAuthentication();
    }
    return sharedPrefs.getString('FIRST_NAME')!;
  }

  String getFirstNameAndLastName() {
    if (!sharedPrefs.containsKey('FIRST_NAME') ||
        sharedPrefs.getString('FIRST_NAME') == null) {
      innitalAuthentication();
    }
    if (!sharedPrefs.containsKey('LAST_NAME') ||
        sharedPrefs.getString('LAST_NAME') == null) {
      innitalAuthentication();
    }
    return '${sharedPrefs.getString('LAST_NAME')} ${sharedPrefs.getString('FIRST_NAME')}';
  }
}
