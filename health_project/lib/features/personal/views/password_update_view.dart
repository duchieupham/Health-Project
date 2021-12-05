import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/enum.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/utils/array_validator.dart';
import 'package:health_project/commons/widgets/header_widget.dart';
import 'package:health_project/commons/widgets/message_widget.dart';
import 'package:health_project/commons/widgets/textfield_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_project/features/personal/blocs/personal_bloc.dart';
import 'package:health_project/features/personal/events/personal_event.dart';
import 'package:health_project/features/personal/states/personal_state.dart';
import 'package:health_project/services/authentication_helper.dart';

class PasswordUpdateView extends StatelessWidget {
  static late final PersonalBloc _personalBloc;
  final String username;
  static final TextEditingController _oldPassword = TextEditingController();
  static final TextEditingController _newPassword = TextEditingController();
  static final TextEditingController _confirmedPassword =
      TextEditingController();
  static bool _isInitial = true;

  const PasswordUpdateView({required this.username});

  void initialServices(BuildContext context) {
    if (_isInitial) {
      _personalBloc = BlocProvider.of(context);
      _isInitial = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    initialServices(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SubHeader(title: 'Đổi mật khẩu'),
          Expanded(
            child: ListView(
              children: [
                //msg box
                BlocConsumer<PersonalBloc, PersonalState>(
                  listener: (context, state) {
                    if (state is PersonalUpdateSuccessState) {
                      //because of stateless widget and having no dispose(). Clear all the textfield before pop.
                      _oldPassword.clear();
                      _newPassword.clear();
                      _confirmedPassword.clear();
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state) {
                    if (state is PersonalUpdateFailState) {
                      return MessageWidget(
                          message: ArrayValidator.instance
                              .getMsgPersonalUpdate(state.type),
                          type: MessageWidgetType.ERROR);
                    }
                    return Container();
                  },
                ),
                //textfield box
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  padding:
                      EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                  decoration: DefaultTheme.cardDecoration(context),
                  child: Column(
                    children: [
                      //
                      TextFieldHDr(
                        style: TFStyle.NO_BORDER,
                        label: '',
                        capitalStyle: TextCapitalization.none,
                        labelTextWidth: 0,
                        placeHolder: 'Mật khẩu cũ',
                        controller: _oldPassword,
                        inputType: TFInputType.TF_PASSWORD,
                        keyboardAction: TextInputAction.next,
                        onChange: (text) {
                          //
                        },
                      ),
                      Divider(
                        height: 1,
                        color: DefaultTheme.GREY_LIGHT,
                      ),
                      TextFieldHDr(
                        style: TFStyle.NO_BORDER,
                        label: '',
                        capitalStyle: TextCapitalization.none,
                        labelTextWidth: 0,
                        placeHolder: 'Mật khẩu mới',
                        controller: _newPassword,
                        inputType: TFInputType.TF_PASSWORD,
                        keyboardAction: TextInputAction.next,
                        onChange: (text) {
                          //
                        },
                      ),
                      Divider(
                        height: 1,
                        color: DefaultTheme.GREY_LIGHT,
                      ),
                      TextFieldHDr(
                        style: TFStyle.NO_BORDER,
                        label: '',
                        capitalStyle: TextCapitalization.none,
                        labelTextWidth: 0,
                        placeHolder: 'Xác nhận mật khẩu',
                        controller: _confirmedPassword,
                        inputType: TFInputType.TF_PASSWORD,
                        keyboardAction: TextInputAction.next,
                        onChange: (text) {
                          //
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //submit button
          _buildButtonWidget(context, 'Cập nhật', onTap: () {
            _personalBloc.add(
              PersonalEventUpdatePassword(
                id: AuthenticateHelper.instance.getAccountId(),
                username: username,
                oldPassword: _oldPassword.text,
                newPassword: _newPassword.text,
                confirmPassword: _confirmedPassword.text,
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
