import 'package:health_project/commons/constants/enum.dart';

class ArrayValidator {
  const ArrayValidator._privateConsrtructor();

  static final ArrayValidator _instance = ArrayValidator._privateConsrtructor();
  static ArrayValidator get instance => _instance;

  //format phone number with prefix +84 for showing views
  String formatPhoneNumber(String phone) {
    String result = '';
    if (phone[0] != '+') {
      phone = '+' + phone;
    }
    if (phone.length != 12) {
      return phone;
    } else {
      result = phone.substring(0, 3) +
          ' ' +
          phone.substring(3, 5) +
          ' ' +
          phone.substring(5, 8) +
          ' ' +
          phone.substring(8, 10) +
          ' ' +
          phone.substring(10, 12);
    }
    return result.trim();
  }

  //format phone number for processing
  String formatPhoneNoForProcessing(String phone) {
    String phoneNumber = '';
    if (phone.length > 0) {
      if (phone[0] == '0') {
        phoneNumber = '84' + phone.substring(1);
      } else if (phone.substring(0, 2) == '84') {
        phoneNumber = phone;
      } else {
        phoneNumber = '84' + phone;
      }
    }
    return phoneNumber;
  }

  //because of having no i18n, translate gender to Vietnamese by this function.
  String formatGender(String gender) {
    String genderFormatted = '';
    if (gender == 'man') {
      genderFormatted = 'Nam';
    } else {
      genderFormatted = 'Nữ';
    }
    return genderFormatted;
  }

  //check valid name
  bool isValidName(String? firstname, String? lastname) {
    return firstname != null &&
        lastname != null &&
        firstname != '' &&
        lastname != '';
  }

  //check valid phone
  bool isValidPhone(String? phone) {
    return phone != null && phone.length >= 9 && phone.length <= 11;
  }

  //check valid address
  bool isValidAddress(String? address) {
    return address != null && address != '';
  }

  //check valid birthday
  bool isValidBirthday(String bDay) {
    if (bDay == '' || bDay == 'n/a') return false;
    DateTime day = DateTime.parse(bDay);
    return day.isBefore(DateTime.now());
  }

  //check valid weight
  bool isValidWeight(double weight) {
    return (weight == 0) ? false : true;
  }

  //process msg when update information
  String getMsgPersonalUpdate(PersonalUpdateMsgType type) {
    String msg = '';
    if (type == PersonalUpdateMsgType.NOT_MATCH_PASSWORD) {
      msg = 'Xác nhận lại mật khẩu không khớp';
    } else if (type == PersonalUpdateMsgType.WRONG_OLD_PASSWORD) {
      msg = 'Mật khẩu cũ không khớp';
    } else if (type == PersonalUpdateMsgType.EMPTY_NEW_PASSWORD) {
      msg = 'Mật khẩu mới không được để trống';
    } else if (type == PersonalUpdateMsgType.INVALID_BIRTHDAY) {
      msg = 'Ngày sinh không hợp lệ';
    } else if (type == PersonalUpdateMsgType.INVALID_NAME) {
      msg = 'Họ tên không hợp lệ';
    } else if (type == PersonalUpdateMsgType.CONFIRMED_OTP) {
      msg = 'Xác thực số điện thoại thành công';
    } else if (type == PersonalUpdateMsgType.DISCONNECT) {
      msg = 'Kiểm tra lại kết nối mạng. Vui lòng thử lại';
    } else if (type == PersonalUpdateMsgType.INVALID_PHONE) {
      msg = 'Số điện thoại không phù hợp';
    } else if (type == PersonalUpdateMsgType.INVALID_ADDRESS) {
      msg = 'Địa chỉ không phù hợp';
    } else if (type == PersonalUpdateMsgType.NOT_CONFIRM_PHONE) {
      msg = 'Số điện thoại chưa được xác thực';
    }
    return msg;
  }

  //process msg when update BMI
  String getMsgBMIUpdate(BMIUpdateMsgType type) {
    String msg = '';
    if (type == BMIUpdateMsgType.INVALID) {
      msg = 'Giá trị cân nặng không hợp lệ. Vui lòng thử lại';
    } else if (type == BMIUpdateMsgType.FAILED) {
      msg = 'Kiểm tra lại kết nối mạng. Vui lòng thử lại.';
    }
    return msg;
  }
}
