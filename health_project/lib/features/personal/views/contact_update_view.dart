import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/enum.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/utils/array_validator.dart';
import 'package:health_project/commons/widgets/header_widget.dart';
import 'package:health_project/commons/widgets/message_widget.dart';
import 'package:health_project/commons/widgets/textfield_widget.dart';
import 'package:health_project/features/personal/blocs/personal_bloc.dart';
import 'package:health_project/features/personal/events/personal_event.dart';
import 'package:health_project/features/personal/states/personal_state.dart';
import 'package:health_project/models/account_contact_dto.dart';
import 'package:health_project/services/phone_confirm_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactUpdateView extends StatelessWidget {
  final AccountContactDTO accountContactDTO;
  static late final PersonalBloc _personalBloc;
  static final TextEditingController _phone = TextEditingController();
  static final TextEditingController _address = TextEditingController();
  static final TextEditingController _pin1 = TextEditingController();
  static final TextEditingController _pin2 = TextEditingController();
  static final TextEditingController _pin3 = TextEditingController();
  static final TextEditingController _pin4 = TextEditingController();
  static final TextEditingController _pin5 = TextEditingController();
  static final TextEditingController _pin6 = TextEditingController();
  static late bool _checkValidPhoneSuccess;
  static late bool _checkMatchWithOldPhone;
  static bool _isInitial = true;

  const ContactUpdateView({required this.accountContactDTO});

  void initialServices(BuildContext context) {
    if (_isInitial) {
      _personalBloc = BlocProvider.of(context);
      _isInitial = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    initialServices(context);
    if (_phone.text.isEmpty) {
      _checkValidPhoneSuccess = false;
      _checkMatchWithOldPhone = true;
      _phone.value = _phone.value.copyWith(text: accountContactDTO.phone);
    }
    if (_address.text.isEmpty) {
      _address.value = _address.value.copyWith(text: accountContactDTO.address);
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SubHeader(title: 'Liên hệ'),
          Expanded(
            child: ListView(
              children: [
                //msg box
                BlocConsumer<PersonalBloc, PersonalState>(
                  listener: (context, state) {
                    if (state is PersonalUpdateSuccessState) {
                      //because of stateless widget and having no dispose(). Clear all the textfield before pop.
                      _phone.clear();
                      _address.clear();
                      _pin1.clear();
                      _pin2.clear();
                      _pin3.clear();
                      _pin4.clear();
                      _pin5.clear();
                      _pin6.clear();
                      Navigator.pop(context);
                    }
                    if (state is PersonalConfirmedOTPState) {
                      _checkValidPhoneSuccess = true;
                      //turn off confirm box
                      Provider.of<PhoneConfirmProvider>(context, listen: false)
                          .updateConfirmedBox(false);
                      Provider.of<PhoneConfirmProvider>(context, listen: false)
                          .updateMatchWithOldPhone(true);
                    }
                  },
                  builder: (context, state) {
                    if (state is PersonalUpdateFailState) {
                      return MessageWidget(
                          message: ArrayValidator.instance
                              .getMsgPersonalUpdate(state.type),
                          type: MessageWidgetType.ERROR);
                    }
                    if (state is PersonalConfirmedOTPState) {
                      return MessageWidget(
                          message: ArrayValidator.instance
                              .getMsgPersonalUpdate(state.type),
                          type: MessageWidgetType.SUCCESS);
                    }
                    return Container();
                  },
                ),
                //phone box
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  padding: EdgeInsets.only(right: 20, bottom: 10, top: 10),
                  decoration: DefaultTheme.cardDecoration(context),
                  child: TextFieldHDr(
                    style: TFStyle.NO_BORDER,
                    label: 'Số điện thoại',
                    controller: _phone,
                    capitalStyle: TextCapitalization.none,
                    labelTextWidth: 120,
                    placeHolder: '093 186 5469',
                    inputType: TFInputType.TF_PHONE,
                    keyboardAction: TextInputAction.next,
                    onChange: (text) {
                      print('phone.text: ${_phone.text}');
                      if (_phone.text != accountContactDTO.phone) {
                        _checkMatchWithOldPhone = false;
                        Provider.of<PhoneConfirmProvider>(context,
                                listen: false)
                            .updateMatchWithOldPhone(false);
                      } else {
                        _checkMatchWithOldPhone = true;
                        Provider.of<PhoneConfirmProvider>(context,
                                listen: false)
                            .updateMatchWithOldPhone(true);
                        Provider.of<PhoneConfirmProvider>(context,
                                listen: false)
                            .updateConfirmedBox(false);
                      }
                    },
                  ),
                ),
                //confirm widget
                Consumer<PhoneConfirmProvider>(
                    builder: (context, phoneConfirm, child) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    alignment: Alignment.centerRight,
                    child: (!phoneConfirm.checkMatchWithOldPhone &&
                            phoneConfirm.confirmedBoxShow)
                        ? ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              //PIN CODE
                              Row(
                                children: [
                                  Flexible(
                                    child: TextFieldHDr(
                                      style: TFStyle.BORDERED,
                                      label: '',
                                      controller: _pin1,
                                      capitalStyle: TextCapitalization.none,
                                      inputType: TFInputType.TF_NUMBER,
                                      keyboardAction: TextInputAction.next,
                                      maxLength: 1,
                                      isMultipleInRow: true,
                                      autoFocus: true,
                                      onChange: (text) {
                                        if (_pin1.text == '') {
                                          FocusScope.of(context)
                                              .previousFocus();
                                        } else {
                                          FocusScope.of(context).nextFocus();
                                        }
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    child: TextFieldHDr(
                                      style: TFStyle.BORDERED,
                                      label: '',
                                      controller: _pin2,
                                      capitalStyle: TextCapitalization.none,
                                      inputType: TFInputType.TF_NUMBER,
                                      keyboardAction: TextInputAction.next,
                                      maxLength: 1,
                                      isMultipleInRow: true,
                                      autoFocus: true,
                                      onChange: (text) {
                                        if (_pin2.text == '') {
                                          FocusScope.of(context)
                                              .previousFocus();
                                        } else {
                                          FocusScope.of(context).nextFocus();
                                        }
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    child: TextFieldHDr(
                                      style: TFStyle.BORDERED,
                                      label: '',
                                      controller: _pin3,
                                      capitalStyle: TextCapitalization.none,
                                      inputType: TFInputType.TF_NUMBER,
                                      keyboardAction: TextInputAction.next,
                                      maxLength: 1,
                                      isMultipleInRow: true,
                                      autoFocus: true,
                                      onChange: (text) {
                                        if (_pin3.text == '') {
                                          FocusScope.of(context)
                                              .previousFocus();
                                        } else {
                                          FocusScope.of(context).nextFocus();
                                        }
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    child: TextFieldHDr(
                                      style: TFStyle.BORDERED,
                                      label: '',
                                      controller: _pin4,
                                      capitalStyle: TextCapitalization.none,
                                      inputType: TFInputType.TF_NUMBER,
                                      keyboardAction: TextInputAction.next,
                                      maxLength: 1,
                                      isMultipleInRow: true,
                                      autoFocus: true,
                                      onChange: (text) {
                                        if (_pin4.text == '') {
                                          FocusScope.of(context)
                                              .previousFocus();
                                        } else {
                                          FocusScope.of(context).nextFocus();
                                        }
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    child: TextFieldHDr(
                                      style: TFStyle.BORDERED,
                                      label: '',
                                      controller: _pin5,
                                      capitalStyle: TextCapitalization.none,
                                      inputType: TFInputType.TF_NUMBER,
                                      keyboardAction: TextInputAction.next,
                                      maxLength: 1,
                                      isMultipleInRow: true,
                                      autoFocus: true,
                                      onChange: (text) {
                                        if (_pin5.text == '') {
                                          FocusScope.of(context)
                                              .previousFocus();
                                        } else {
                                          FocusScope.of(context).nextFocus();
                                        }
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    child: TextFieldHDr(
                                      style: TFStyle.BORDERED,
                                      label: '',
                                      controller: _pin6,
                                      capitalStyle: TextCapitalization.none,
                                      inputType: TFInputType.TF_NUMBER,
                                      keyboardAction: TextInputAction.next,
                                      maxLength: 1,
                                      isMultipleInRow: true,
                                      autoFocus: true,
                                      onChange: (text) {
                                        if (_pin6.text == '') {
                                          FocusScope.of(context)
                                              .previousFocus();
                                        } else {
                                          //
                                          String _pinCode = _pin1.text +
                                              _pin2.text +
                                              _pin3.text +
                                              _pin4.text +
                                              _pin5.text +
                                              _pin6.text;
                                          print('pincode: $_pinCode');
                                          _personalBloc.add(
                                            PersonalEventConfirmOTP(
                                                otp: _pinCode),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              //
                              Text(
                                'Nhập mã xác thực được gửi về điện thoại của bạn.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: DefaultTheme.GREY_TEXT,
                                ),
                              ),
                            ],
                          )
                        : (!phoneConfirm.checkMatchWithOldPhone &&
                                !phoneConfirm.confirmedBoxShow)
                            ? InkWell(
                                onTap: () {
                                  phoneConfirm.updateConfirmedBox(true);
                                  _personalBloc.add(
                                    PersonalEventConfirmPhoneNumber(
                                      phoneNumber: ArrayValidator.instance
                                          .formatPhoneNoForProcessing(
                                              _phone.text.trim()),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Gửi mã xác thực',
                                  style: TextStyle(
                                    color: DefaultTheme.SUCCESS_STATUS,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              )
                            : Container(),
                  );
                }),
                //address
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  padding: EdgeInsets.only(right: 20, bottom: 10, top: 10),
                  decoration: DefaultTheme.cardDecoration(context),
                  child: TextFieldHDr(
                    style: TFStyle.NO_BORDER,
                    label: 'Địa chỉ',
                    controller: _address,
                    capitalStyle: TextCapitalization.none,
                    labelTextWidth: 80,
                    inputType: TFInputType.TF_TEXT,
                    keyboardAction: TextInputAction.next,
                    onChange: (text) {
                      //
                    },
                  ),
                ),
              ],
            ),
          ),
          //submit button
          _buildButtonWidget(context, 'Cập nhật', onTap: () {
            AccountContactDTO _accountContactUpdatedDTO = AccountContactDTO(
                id: accountContactDTO.id,
                address: _address.text,
                phone: _phone.text);
            bool _isConfirmedPhone = false;
            if ((_checkMatchWithOldPhone && !_checkValidPhoneSuccess) ||
                (!_checkMatchWithOldPhone && _checkValidPhoneSuccess)) {
              //
              _isConfirmedPhone = true;
            }
            _personalBloc.add(
              PersonalEventUpdateContact(
                dto: _accountContactUpdatedDTO,
                isConfirmedPhone: _isConfirmedPhone,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildButtonWidget(BuildContext context, String text,
      {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 30, left: 20, right: 20),
        padding: EdgeInsets.only(top: 15, bottom: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: DefaultTheme.BLUE_TEXT,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: DefaultTheme.WHITE,
          ),
        ),
      ),
    );
  }
}
