import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/theme.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final String buttonTitle;
  final Color color;
  final bool subButton;
  final VoidCallback? onTap;

  const TitleWidget({
    required this.title,
    required this.buttonTitle,
    required this.color,
    required this.subButton,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 3,
            color: color,
          ),
        ),
      ),
      child: (!subButton)
          ? Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                InkWell(
                  onTap: onTap,
                  child: Text(
                    buttonTitle,
                    style: TextStyle(
                      color: DefaultTheme.BLUE_TEXT,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
