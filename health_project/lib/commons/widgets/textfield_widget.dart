import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/theme.dart';

// ignore: must_be_immutable
class TextFieldHDr extends StatelessWidget {
  //controller of textfield
  final TextEditingController? controller;
  //action onChange
  final ValueChanged<Object>? onChange;
  //label of textfield
  final String? label;
  //The view of keyboard and the value view in textfield
  final TFInputType? inputType;
  //the action of keyboard
  final TextInputAction? keyboardAction;
  //the desc. in textfield.
  final String? placeHolder;
  //helper Text is shown below the textfield for help people inut right
  final String? helperText;
  //maximum Length of text field
  final int? maxLength;
  //style capitalization
  final TextCapitalization? capitalStyle;
  //style of textfield
  final TFStyle? style;
  //unit of textfield
  final String? unit;
  //flag for multiple textfield in row
  final bool? isMultipleInRow;
  //auto focus textfield
  final bool? autoFocus;
  //LABEL_TEXTFIELD_WIDTH
  final double? labelTextWidth;

  const TextFieldHDr({
    Key? key,
    this.controller,
    this.label,
    this.inputType,
    this.keyboardAction,
    this.placeHolder,
    this.helperText,
    this.maxLength,
    this.capitalStyle,
    this.style,
    this.unit,
    this.isMultipleInRow,
    this.autoFocus,
    this.labelTextWidth,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (style!) {
      case TFStyle.NO_BORDER:
        return Material(
          color: DefaultTheme.TRANSPARENT,
          child: Row(
            children: [
              Container(
                color: DefaultTheme.TRANSPARENT,
                padding: EdgeInsets.only(left: 20),
                width: (labelTextWidth == null) ? 150 : labelTextWidth,
                height: 40,
                alignment: Alignment.centerLeft,
                child: Text(
                  '$label',
                  // maxLines: 1,
                  // overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              Flexible(
                child: TextField(
                  // autofocus: true,
                  obscureText:
                      (inputType == TFInputType.TF_PASSWORD) ? true : false,
                  keyboardType: (inputType == TFInputType.TF_NUMBER)
                      ? TextInputType.number
                      : (inputType == TFInputType.TF_EMAIL)
                          ? TextInputType.emailAddress
                          : (inputType == TFInputType.TF_PHONE)
                              ? TextInputType.phone
                              : (inputType == TFInputType.TF_TEXT)
                                  ? TextInputType.text
                                  : null,
                  textInputAction: keyboardAction,
                  textCapitalization: capitalStyle!,
                  maxLength: maxLength,
                  buildCounter: (BuildContext? context,
                          {int? currentLength,
                          int? maxLength,
                          bool? isFocused}) =>
                      null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: placeHolder,
                    hintStyle: TextStyle(
                        color: DefaultTheme.GREY_TEXT.withOpacity(0.7)),
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  onChanged: onChange,
                  controller: controller,
                ),
              ),
            ],
          ),
        );

      case TFStyle.BORDERED:
        return Material(
          color: DefaultTheme.TRANSPARENT,
          child: Row(
            children: [
              if (isMultipleInRow == false)
                Padding(padding: EdgeInsets.only(left: 20)),
              Padding(padding: EdgeInsets.only(left: 2.5)),
              Flexible(
                child: TextField(
                  textAlign: (isMultipleInRow == true)
                      ? TextAlign.center
                      : TextAlign.left,
                  autofocus: autoFocus!,
                  obscureText:
                      (inputType == TFInputType.TF_PASSWORD) ? true : false,
                  keyboardType: (inputType == TFInputType.TF_NUMBER)
                      ? TextInputType.number
                      : (inputType == TFInputType.TF_EMAIL)
                          ? TextInputType.emailAddress
                          : (inputType == TFInputType.TF_PHONE)
                              ? TextInputType.phone
                              : (inputType == TFInputType.TF_TEXT)
                                  ? TextInputType.text
                                  : null,
                  textInputAction: keyboardAction,
                  textCapitalization: capitalStyle!,
                  maxLength: maxLength,
                  decoration: InputDecoration(
                    counter: Offstage(),
                    labelText: label,
                    helperText: helperText,
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        width: 0.25,
                        color: DefaultTheme.TRANSPARENT,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        width: 0.25,
                        color: DefaultTheme.TRANSPARENT,
                      ),
                    ),
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  onChanged: onChange,
                  controller: controller,
                ),
              ),
              if (isMultipleInRow == false)
                Padding(padding: EdgeInsets.only(left: 20)),
              Padding(padding: EdgeInsets.only(left: 2.5)),
            ],
          ),
        );

      case TFStyle.TEXT_AREA:
        return Material(
          color: DefaultTheme.TRANSPARENT,
          child: Row(
            children: [
              if (isMultipleInRow == false)
                Padding(padding: EdgeInsets.only(left: 20)),
              Padding(padding: EdgeInsets.only(left: 2.5)),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: DefaultTheme.GREY_VIEW,
                  ),
                  child: TextFormField(
                    autofocus: false,
                    onChanged: onChange,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    controller: controller,
                    textInputAction: keyboardAction,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          fontSize: 15,
                          color: DefaultTheme.GREY_TEXT.withOpacity(0.8)),
                      hintText: placeHolder,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(20),
                    ),
                  ),
                ),
              ),
              if (isMultipleInRow == false)
                Padding(padding: EdgeInsets.only(left: 20)),
              Padding(padding: EdgeInsets.only(left: 2.5)),
            ],
          ),
        );

      case TFStyle.UNIT:
        return Material(
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  // autofocus: true,
                  textAlign: TextAlign.right,
                  obscureText:
                      (inputType == TFInputType.TF_PASSWORD) ? true : false,
                  keyboardType: (inputType == TFInputType.TF_NUMBER)
                      ? TextInputType.number
                      : (inputType == TFInputType.TF_EMAIL)
                          ? TextInputType.emailAddress
                          : (inputType == TFInputType.TF_PHONE)
                              ? TextInputType.phone
                              : (inputType == TFInputType.TF_TEXT)
                                  ? TextInputType.text
                                  : null,
                  textInputAction: keyboardAction,
                  textCapitalization: capitalStyle!,
                  maxLength: maxLength,
                  decoration: InputDecoration(
                    counter: Offstage(),
                    hintText: label,
                    filled: true,
                    fillColor: DefaultTheme.GREY_BUTTON.withOpacity(0.8),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(20, 0, 20 * 2 + 10, 0),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        width: 0.25,
                        color: DefaultTheme.TRANSPARENT,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        width: 0.25,
                        color: DefaultTheme.TRANSPARENT,
                      ),
                    ),
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
              Positioned(
                right: 20 * 2,
                top: 14,
                child: Text(
                  unit!,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }
}

enum TFInputType {
  TF_PASSWORD,
  TF_TEXT,
  TF_NUMBER,
  TF_PHONE,
  TF_EMAIL,
}

enum TFStyle {
  NO_BORDER,
  BORDERED,
  UNIT,
  TEXT_AREA,
}
