import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/enum.dart';
import 'package:health_project/commons/constants/theme.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  final MessageWidgetType type;

  @override
  const MessageWidget({Key? key, required this.message, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20, right: 20),
      padding: EdgeInsets.only(bottom: 8, top: 8),
      decoration: BoxDecoration(
        color: (type == MessageWidgetType.ERROR)
            ? DefaultTheme.RED_CALENDAR.withOpacity(0.8)
            : (type == MessageWidgetType.LOADING)
                ? DefaultTheme.BLUE_TEXT.withOpacity(0.8)
                : (type == MessageWidgetType.SUCCESS)
                    ? DefaultTheme.SUCCESS_STATUS.withOpacity(0.8)
                    : DefaultTheme.NEON,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          SizedBox(
            width: 20,
            height: 20,
            child: (type == MessageWidgetType.ERROR)
                ? Image.asset('assets/images/ic-validate.png')
                : (type == MessageWidgetType.LOADING)
                    ? Image.asset('assets/images/ic-loading.png')
                    : (type == MessageWidgetType.SUCCESS)
                        ? Image.asset('assets/images/ic-success.png')
                        : Image.asset('assets/images/ic-warning.png'),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 80,
            child: Text(
              '$message',
              style: TextStyle(color: DefaultTheme.WHITE, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
