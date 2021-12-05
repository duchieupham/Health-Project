import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_project/commons/constants/enum.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/utils/array_validator.dart';
import 'package:health_project/commons/widgets/header_widget.dart';
import 'package:health_project/commons/widgets/message_widget.dart';
import 'package:health_project/commons/widgets/textfield_widget.dart';
import 'package:health_project/features/health/blocs/health_bloc.dart';
import 'package:health_project/features/health/events/health_event.dart';
import 'package:health_project/features/health/states/health_state.dart';
import 'package:health_project/models/bmi_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BMIUpdateView extends StatelessWidget {
  final BMIDTO bmiDTO;
  static late final BMIBloc _bmiBloc;
  static final List<int> _heightList = Iterable<int>.generate(200).toList();
  static final TextEditingController _weightController =
      TextEditingController();
  static bool _isInitial = true;
  static late double _height;
  static late double _weight;

  const BMIUpdateView({required this.bmiDTO});

  void initialServices(BuildContext context) {
    if (_isInitial) {
      _bmiBloc = BlocProvider.of(context);
      _height = bmiDTO.height;
      _isInitial = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    initialServices(context);
    if (_weightController.text.isEmpty) {
      _weightController.value = _weightController.value.copyWith(
        text: bmiDTO.weight.toInt().toString(),
      );
      _weight = double.parse(_weightController.text);
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SubHeader(title: 'Cập nhật BMI'),
          Expanded(
            child: ListView(
              children: [
                //msg box
                BlocConsumer<BMIBloc, HealthState>(
                  listener: (context, state) {
                    if (state is BMIUpdateSuccessState) {
                      _weightController.clear();
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state) {
                    if (state is BMIUpdateFailedState) {
                      return MessageWidget(
                          message: ArrayValidator.instance
                              .getMsgBMIUpdate(state.type),
                          type: MessageWidgetType.ERROR);
                    }
                    return Container();
                  },
                ),
                //update components
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  padding: EdgeInsets.only(right: 20, bottom: 10, top: 10),
                  decoration: DefaultTheme.cardDecoration(context),
                  child: TextFieldHDr(
                    style: TFStyle.NO_BORDER,
                    label: 'Cân nặng',
                    capitalStyle: TextCapitalization.words,
                    labelTextWidth: 120,
                    controller: _weightController,
                    inputType: TFInputType.TF_NUMBER,
                    keyboardAction: TextInputAction.next,
                    onChange: (text) {
                      if (double.tryParse(_weightController.text) != null &&
                          _weightController.text != '') {
                        _weight = double.parse(_weightController.text);
                      } else {
                        _weight = 0;
                      }
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  padding:
                      EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                  decoration: DefaultTheme.cardDecoration(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chiều cao',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 160,
                        height: 200,
                        child: CupertinoTheme(
                          data: CupertinoThemeData(
                            textTheme: CupertinoTextThemeData(
                              textStyle: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).focusColor,
                              ),
                            ),
                          ),
                          child: CupertinoPicker(
                            itemExtent: 35,
                            diameterRatio: 1,
                            scrollController: FixedExtentScrollController(
                              initialItem: _height.toInt() - 1,
                            ),
                            children: _listHeight(),
                            onSelectedItemChanged: (value) {
                              SystemSound.play(SystemSoundType.click);
                              _height = value + 1;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //submit button
          _buildButtonWidget(context, 'Cập nhật', onTap: () {
            final BMIDTO _bmiUpdatedDTO = BMIDTO(
                gender: bmiDTO.gender,
                height: _height,
                weight: _weight,
                id: bmiDTO.id);
            _bmiBloc.add(BMIEventUpdate(dto: _bmiUpdatedDTO));
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

  List<Widget> _listHeight() {
    return _heightList.map((e) {
      return Align(
        alignment: Alignment.center,
        child: Text(
          '${e + 1} cm',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      );
    }).toList();
  }
}
