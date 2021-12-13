import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/enum.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/utils/health_util.dart';
import 'package:health_project/commons/utils/time_util.dart';
import 'package:health_project/features/health/blocs/health_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_project/features/health/events/health_event.dart';
import 'package:health_project/features/health/states/health_state.dart';
import 'package:health_project/models/vital_sign_dto.dart';
import 'package:health_project/services/authentication_helper.dart';
import 'package:health_project/services/tab_provider.dart';
import 'package:provider/provider.dart';

class VitalSignHistoryView extends StatelessWidget {
  final ChartType type;
  final String valueType;
  static bool _isInitial = true;
  static int _indexTab = 0;
  static late final HeartRateBloc _heartRateBloc;
  static final Map<String, List<VitalSignDTO>> _vitalSignLists = {};

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
    _vitalSignLists.clear();
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
    _indexTab = 0;
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
                  child: Consumer<TabProvider>(builder: (context, tab, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            tab.updateTabIndex(0);
                            _indexTab = 0;
                            _getEvents();
                          },
                          child: Container(
                            width: 60,
                            alignment: Alignment.center,
                            decoration: (tab.tabIndex == 0)
                                ? _selectedBox(context)
                                : null,
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
                          onTap: () {
                            tab.updateTabIndex(1);
                            _indexTab = 1;
                            _getEvents();
                          },
                          child: Container(
                            width: 60,
                            alignment: Alignment.center,
                            decoration: (tab.tabIndex == 1)
                                ? _selectedBox(context)
                                : null,
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
                          onTap: () {
                            tab.updateTabIndex(2);
                            _indexTab = 2;
                            _getEvents();
                          },
                          child: Container(
                            width: 60,
                            alignment: Alignment.center,
                            decoration: (tab.tabIndex == 2)
                                ? _selectedBox(context)
                                : null,
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
                    );
                  }),
                ),
                Expanded(
                  child: BlocConsumer<HeartRateBloc, HealthState>(
                    listener: (context, state) {
                      if (state is HeartRateSuccessfulListState) {
                        if (state.list.isNotEmpty) {
                          for (VitalSignDTO dto in state.list.reversed) {
                            String key = '';
                            if (_indexTab == 0) {
                              key = dto.time.split(' ')[0];
                            } else if (_indexTab == 1) {
                              key = TimeUtil.instance.getMonthAndYear(dto.time);
                            } else {
                              key = dto.time.split(' ')[0].split('-')[0];
                            }
                            if (_vitalSignLists[key] == null) {
                              _vitalSignLists[key] = [];
                            }
                            _vitalSignLists[key]!.add(dto);
                          }
                        }
                      }
                    },
                    buildWhen: (previous, current) =>
                        previous != current &&
                        current is HeartRateSuccessfulListState,
                    builder: (context, state) {
                      return (_vitalSignLists.isNotEmpty &&
                              state is HeartRateSuccessfulListState)
                          ? ListView.builder(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              itemCount: _vitalSignLists.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    (index != 0)
                                        ? Padding(
                                            padding: EdgeInsets.only(top: 20))
                                        : Container(),
                                    Text(
                                      HealthUtil.instance.formatTimeHistory(
                                        _indexTab,
                                        _vitalSignLists.keys.elementAt(index),
                                      ),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'NewYork',
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 10)),
                                    for (VitalSignDTO dto in _vitalSignLists
                                        .values
                                        .elementAt(index))
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.only(bottom: 10),
                                        padding: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            bottom: 10,
                                            top: 10),
                                        decoration: DefaultTheme.cardDecoration(
                                            context),
                                        child: Text('${dto.value1} bpm'),
                                      )
                                  ],
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
