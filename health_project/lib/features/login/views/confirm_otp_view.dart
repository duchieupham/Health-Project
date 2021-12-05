import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/enum.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/routes/routes.dart';
import 'package:health_project/commons/utils/array_validator.dart';
import 'package:health_project/commons/widgets/message_widget.dart';
import 'package:health_project/commons/widgets/textfield_widget.dart';
import 'package:health_project/features/home/home_view.dart';
import 'package:health_project/features/login/blocs/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_project/features/login/events/login_event.dart';
import 'package:health_project/features/login/states/login_state.dart';

class ConfirmOTPView extends StatefulWidget {
  final String phoneNumber;

  const ConfirmOTPView({required this.phoneNumber});

  @override
  State<StatefulWidget> createState() => _ConfirmOTPView(phoneNumber);
}

class _ConfirmOTPView extends State<ConfirmOTPView> {
  //blocs
  late final LoginBloc _loginBloc;

  //variables
  final String _phoneNumber;
  final _otpController = TextEditingController();

  @override
  _ConfirmOTPView(this._phoneNumber);

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, left: 10),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(8),
              height: 40,
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset(
                  'assets/images/ic-pop.png',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              child: SizedBox(
                width: 80,
                height: 80,
                child: Image.asset('assets/images/ic-otp.png'),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: const Text(
                'Xác nhận mã OTP',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(left: 20, right: 20),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).hintColor,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                        text: 'Vui lòng nhập mã được gửi đến số điện thoại '),
                    TextSpan(
                        text:
                            '${ArrayValidator.instance.formatPhoneNumber(_phoneNumber)}',
                        style: TextStyle(
                          color: DefaultTheme.SUCCESS_STATUS,
                          fontWeight: FontWeight.w500,
                        )),
                    const TextSpan(text: ' để đăng nhập vào hệ thống.'),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
              padding: EdgeInsets.only(bottom: 5, top: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFieldHDr(
                style: TFStyle.NO_BORDER,
                label: 'OTP',
                labelTextWidth: 60,
                capitalStyle: TextCapitalization.none,
                placeHolder: 'Nhập mã ở đây',
                controller: _otpController,
                inputType: TFInputType.TF_NUMBER,
                keyboardAction: TextInputAction.done,
                onChange: (text) {
                  //
                },
              ),
            ),
            BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccessState) {
                  // Navigator.of(context)
                  //     .pushReplacementNamed(Routes.INITIAL_ROUTE);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomeView(),
                    ),
                    ModalRoute.withName(Routes.INITIAL_ROUTE),
                  );
                }
              },
              buildWhen: (context, state) =>
                  state is LoginFailedState || state is LoginProcessingState,
              builder: (context, state) {
                return (state is LoginFailedState)
                    ? MessageWidget(
                        type: MessageWidgetType.ERROR, message: state.msg)
                    : (state is LoginProcessingState)
                        ? MessageWidget(
                            type: MessageWidgetType.LOADING,
                            message: 'Đang đăng nhập')
                        : Container();
              },
            ),
            Spacer(),
            InkWell(
              onTap: () {
                _loginBloc.add(
                  CheckOTPCodeEvent(
                    code: _otpController.text.trim(),
                    phone: _phoneNumber,
                  ),
                );
              },
              splashColor: DefaultTheme.TRANSPARENT,
              highlightColor: DefaultTheme.TRANSPARENT,
              hoverColor: DefaultTheme.TRANSPARENT,
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width - 40,
                height: 55,
                decoration: BoxDecoration(
                  color: DefaultTheme.BLACK_BUTTON,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(
                    color: DefaultTheme.WHITE,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      //   ),
    );
  }
}
