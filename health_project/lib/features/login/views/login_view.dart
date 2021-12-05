import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/enum.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/routes/routes.dart';
import 'package:health_project/commons/utils/array_validator.dart';
import 'package:health_project/commons/widgets/message_widget.dart';
import 'package:health_project/commons/widgets/textfield_widget.dart';
import 'package:health_project/features/login/blocs/login_bloc.dart';
import 'package:health_project/features/login/events/login_event.dart';
import 'package:health_project/features/login/states/login_state.dart';
import 'package:health_project/features/login/views/confirm_otp_view.dart';
import 'package:health_project/services/tab_login_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart' as rive;

class LoginView extends StatefulWidget {
  const LoginView();

  @override
  _LoginView createState() => _LoginView();
}

class _LoginView extends State<LoginView> {
  //bloc
  late final LoginBloc _loginBloc;

  //textfield controllers
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  //animation
  late final rive.StateMachineController _riveController;
  late rive.SMITrigger _action;
  static const ANIMATION_DEFAULT_STATE = 'Keep initial';
  static const STATE_MACHINE_ANIMATION = 'Logo state machine';
  bool _isRiveInit = false;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    if (_isRiveInit) {
      _riveController.dispose();
    }
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _loginBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<TabLoginProvider>(
          builder: (context, tabSelect, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: rive.RiveAnimation.asset(
                          'assets/rives/logo.riv',
                          fit: BoxFit.fitHeight,
                          antialiasing: false,
                          animations: [ANIMATION_DEFAULT_STATE],
                          onInit: _onRiveInit,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                      ),
                      _buildTab(tabSelect),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                      ),
                      _buildLoginProcess(tabSelect.tabIndex),
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                        //
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _buildFormField(tabSelect.tabIndex),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 20, right: 10),
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            //
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: const Text(
                              'Đăng kí tài khoản mới',
                              style: TextStyle(
                                  fontSize: 13, color: DefaultTheme.BLUE_TEXT),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildSubmitButton(tabSelect.tabIndex),
                Container(
                  margin: EdgeInsets.only(bottom: 10, top: 5),
                  child: const Text(
                    'Powered by HealthProject',
                    style: TextStyle(
                      color: DefaultTheme.GREY_TEXT,
                      fontSize: 13,
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  _buildLoginProcess(int tabSelect) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          Navigator.of(context).pushReplacementNamed(Routes.HOME);
        }
        if (state is LoginFailedState) {
          _doBackInitAnimation();
        }
        if (state is LoginFirebaseSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfirmOTPView(
                phoneNumber: ArrayValidator.instance
                    .formatPhoneNoForProcessing(_phoneController.text),
              ),
            ),
          ).then((_) {
            Future.microtask(() {
              _doBackInitAnimation();
            });
          });
        }
      },
      buildWhen: (context, state) =>
          state is LoginFailedState || state is LoginProcessingState,
      builder: (context, state) {
        return (state is LoginFailedState)
            ? MessageWidget(type: MessageWidgetType.ERROR, message: state.msg)
            : (state is LoginProcessingState)
                ? MessageWidget(
                    type: MessageWidgetType.LOADING, message: 'Đang đăng nhập')
                : Container();
      },
    );
  }

  //initial of animation
  _onRiveInit(rive.Artboard artboard) {
    _riveController = rive.StateMachineController.fromArtboard(
        artboard, STATE_MACHINE_ANIMATION)!;
    artboard.addController(_riveController);
    _isRiveInit = true;
    _doInitAnimation();
  }

  _buildSubmitButton(int index) {
    return InkWell(
      onTap: () {
        _doSubmitAnimation();
        Future.delayed(Duration(milliseconds: 1000), () {
          _loginBloc.add(
            (index == 0)
                ? LoginByAccountEvent(
                    username: _usernameController.text.trim(),
                    password: _passwordController.text.trim(),
                  )
                : LoginByPhoneEvent(
                    phone: ArrayValidator.instance.formatPhoneNoForProcessing(
                      _phoneController.text,
                    ),
                  ),
          );
        });
      },
      splashColor: DefaultTheme.TRANSPARENT,
      highlightColor: DefaultTheme.TRANSPARENT,
      hoverColor: DefaultTheme.TRANSPARENT,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width - 40,
        height: 55,
        decoration: BoxDecoration(
          color: (index == 0)
              ? DefaultTheme.BLACK_BUTTON
              : DefaultTheme.SUCCESS_STATUS,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          (index == 0) ? 'Đăng nhập' : 'Tiếp theo',
          style: TextStyle(
            color: DefaultTheme.WHITE,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  _buildFormField(int tabSelect) {
    return (tabSelect == 0)
        ? Column(
            children: [
              TextFieldHDr(
                style: TFStyle.NO_BORDER,
                label: 'Tên đăng nhập',
                capitalStyle: TextCapitalization.none,
                labelTextWidth: 130,
                placeHolder: 'username123',
                inputType: TFInputType.TF_TEXT,
                controller: _usernameController,
                keyboardAction: TextInputAction.next,
                onChange: (text) {
                  //
                },
              ),
              Divider(
                color: DefaultTheme.GREY_TOP_TAB_BAR,
                height: 1,
              ),
              TextFieldHDr(
                style: TFStyle.NO_BORDER,
                label: 'Mật khẩu',
                capitalStyle: TextCapitalization.none,
                labelTextWidth: 130,
                placeHolder: '••••••',
                inputType: TFInputType.TF_PASSWORD,
                controller: _passwordController,
                keyboardAction: TextInputAction.done,
                onChange: (text) {
                  //
                },
              ),
            ],
          )
        : Container(
            child: TextFieldHDr(
              style: TFStyle.NO_BORDER,
              capitalStyle: TextCapitalization.none,
              label: '+84',
              labelTextWidth: 50,
              placeHolder: 'Số điện thoại',
              inputType: TFInputType.TF_PHONE,
              controller: _phoneController,
              keyboardAction: TextInputAction.done,
              onChange: (text) {
                //
              },
            ),
          );
  }

  _buildTab(TabLoginProvider tabSelect) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20),
          ),
          Container(
            height: 35,
            alignment: Alignment.centerLeft,
            child: const Text(
              'Đăng nhập với: ',
              style: TextStyle(
                fontSize: 13,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20),
          ),
          _buildTabButton(tabSelect, 0),
          const Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          _buildTabButton(tabSelect, 1),
        ],
      ),
    );
  }

  _buildTabButton(TabLoginProvider tabProvider, int index) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: () {
        tabProvider.updateTabIndex(index);
      },
      child: AnimatedContainer(
        alignment: Alignment.center,
        width: (tabProvider.tabIndex == index) ? 150 : 35,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(40),
        ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Image.asset((index == 0)
                  ? 'assets/images/ic-field-username.png'
                  : 'assets/images/ic-field-phone.png'),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: (tabProvider.tabIndex == index) ? 10 : 0),
            ),
            UnconstrainedBox(
              child: Text(
                (tabProvider.tabIndex == index) ? 'Tài khoản Health' : '',
                softWrap: false,
                style: TextStyle(
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _doInitAnimation() {
    _action = _riveController.findInput<bool>('do init') as rive.SMITrigger;
    _action.fire();
  }

  void _doSubmitAnimation() {
    _action = _riveController.findInput<bool>('submit') as rive.SMITrigger;
    _action.fire();
  }

  void _doBackInitAnimation() {
    _action = _riveController.findInput<bool>('back init') as rive.SMITrigger;
    _action.fire();
  }
}
