import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/routes/routes.dart';
import 'package:health_project/commons/widgets/header_widget.dart';
import 'package:rive/rive.dart' as rive;

class IntroConnectView extends StatefulWidget {
  const IntroConnectView();

  @override
  State<StatefulWidget> createState() => _IntroConnectView();
}

class _IntroConnectView extends State<IntroConnectView> {
  //
  //animation
  late final rive.StateMachineController _riveController;
  late rive.SMITrigger _action;
  static const ANIMATION_DEFAULT_STATE = 'To intro';
  static const STATE_MACHINE_ANIMATION = 'Intro connect st. machine';
  bool _isRiveInit = false;
  bool _isClicked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_isRiveInit) {
      _riveController.dispose();
    }
    super.dispose();
  }

//initial of animation
  _onRiveInit(rive.Artboard artboard) {
    _riveController = rive.StateMachineController.fromArtboard(
        artboard, STATE_MACHINE_ANIMATION)!;
    artboard.addController(_riveController);
    _isRiveInit = true;
    _doInitAnimation();
  }

  void _doInitAnimation() {
    _action = _riveController.findInput<bool>('do init') as rive.SMITrigger;
    _action.fire();
  }

  void _doStartConnectAnimation() {
    _action =
        _riveController.findInput<bool>('start connect') as rive.SMITrigger;
    _action.fire();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SubHeader(title: ''),
            SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              height: MediaQuery.of(context).size.width - 40,
              child: rive.RiveAnimation.asset(
                'assets/rives/logo.riv',
                fit: BoxFit.fitWidth,
                antialiasing: true,
                animations: [ANIMATION_DEFAULT_STATE],
                onInit: _onRiveInit,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Kết nối thiết bị',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 50,
                      right: 50,
                      top: 10,
                      bottom: 30,
                    ),
                    child: Text(
                      'Các thông tin về sức khoẻ của bạn được cập nhật xuyên suốt thông qua thiết bị được ghép nối.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                //because of having delay, avoid user click 2 times

                if (!_isClicked) {
                  _isClicked = true;
                  _doStartConnectAnimation();
                  Future.delayed(Duration(seconds: 1)).then((value) async {
                    await Navigator.pushReplacementNamed(
                        context, Routes.CONNECT_PERIPHERAL_VIEW);
                  });
                }
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width - 40,
                height: 55,
                margin: EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  color: DefaultTheme.BLACK_BUTTON,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Kết nối',
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
    );
  }
}
