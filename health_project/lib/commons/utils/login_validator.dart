class LoginValidator {
  const LoginValidator._privateConsrtructor();

  static final LoginValidator _instance = LoginValidator._privateConsrtructor();
  static LoginValidator get instance => _instance;

  //check valid username
  bool isValidUsername(String? username) {
    return username != null && username.length >= 6;
  }

  //check valid password
  bool isValidPassword(String? password) {
    return password != null && password.length >= 6;
  }

  //check valid phone
  bool isValidPhone(String? phone) {
    return phone != null && phone.length >= 9 && phone.length <= 11;
  }
}
