import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/enum.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/utils/health_util.dart';
import 'package:health_project/features/health/blocs/health_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_project/features/health/events/health_event.dart';
import 'package:health_project/features/health/states/health_state.dart';
import 'package:health_project/models/vital_sign_dto.dart';
import 'package:health_project/services/authentication_helper.dart';

class VitalSignHistoryView extends StatelessWidget {
  final ChartType type;
  final String valueType;
  static bool _isInitial = true;
  static late final HeartRateBloc _heartRateBloc;
  static final List<VitalSignDTO> _vitalSignList = [];

  const VitalSignHistoryView({
    required this.type,
    required this.valueType,
  });

  void initialServices(BuildContext context) {
    if (_isInitial) {
      _heartRateBloc = BlocProvider.of(context);
      _isInitial = false;
    }
  }

  void _getEvents() {
    VitalSignDTO dto = VitalSignDTO(
      id: 'n/a',
      accountId: AuthenticateHelper.instance.getAccountId(),
      value1: 0,
      value2: 0,
      time: DateTime.now().toString(),
      type: valueType,
    );
    _heartRateBloc.add(HeartRateGetListEvent(dto: dto, chartType: type));
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitial) {
      initialServices(context);
    }
    _getEvents();
    String _title = HealthUtil.instance.getVitalSignNameByValueType(valueType);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: ClipRRect(
        child: Padding(
          padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
          child: Container(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
            ),
            width: MediaQuery.of(context).size.width - 10,
            height: MediaQuery.of(context).size.height * 0.95,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(33.33),
              color: Theme.of(context).hoverColor,
            ),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 80,
                        height: 60,
                      ),
                      Container(
                        height: 60,
                        alignment: Alignment.center,
                        child: Text(
                          'Dữ liệu $_title',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 80,
                          height: 60,
                          padding: EdgeInsets.only(right: 10),
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Đóng',
                            style: TextStyle(
                              color: DefaultTheme.BLUE_TEXT,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 200,
                  height: 30,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Theme.of(context).cardColor.withOpacity(0.6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 60,
                          alignment: Alignment.center,
                          decoration: _selectedBox(context),
                          child: Text(
                            'Ngày',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 5)),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 60,
                          alignment: Alignment.center,
                          decoration: null,
                          child: Text(
                            'Tháng',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 5)),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 60,
                          alignment: Alignment.center,
                          decoration: null,
                          child: Text(
                            'Năm',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocConsumer<HeartRateBloc, HealthState>(
                    listener: (context, state) {
                      if (state is HeartRateSuccessfulListState) {
                        _vitalSignList.clear();
                        if (state.list.isNotEmpty) {
                          for (VitalSignDTO dto in state.list.reversed) {
                            _vitalSignList.add(dto);
                          }
                        }
                      }
                    },
                    buildWhen: (previous, current) =>
                        previous != current &&
                        current is HeartRateSuccessfulListState,
                    builder: (context, state) {
                      return (_vitalSignList.isNotEmpty)
                          ? ListView.builder(
                              itemCount: _vitalSignList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                      '${_vitalSignList[index].time} - ${_vitalSignList[index].value1}'),
                                );
                              },
                            )
                          : Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _selectedBox(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).buttonColor,
      borderRadius: BorderRadius.circular(4),
    );
  }
}
