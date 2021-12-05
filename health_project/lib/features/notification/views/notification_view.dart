import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/utils/time_util.dart';
import 'package:health_project/features/notification/blocs/notification_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_project/features/notification/events/notification_event.dart';
import 'package:health_project/features/notification/states/notification_state.dart';
import 'package:health_project/models/notification_dto.dart';
import 'package:health_project/services/authentication_helper.dart';

class NotificationView extends StatelessWidget {
  static final List<NotificationDTO> _listNotification = [];
  static final List<bool> _listCheck = [];
  static late final NotificationBloc _notificationBloc;
  static bool _isInitial = false;
  const NotificationView(Key key) : super(key: key);

  void initialServices(BuildContext context) {
    if (!_isInitial) {
      _notificationBloc = BlocProvider.of(context);
    }
    _isInitial = true;
  }

  @override
  Widget build(BuildContext context) {
    initialServices(context);
    //check not rebuild when changing theme.
    if (_listNotification.isEmpty) _getEvent(_notificationBloc);
    return RefreshIndicator(
      child: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationSuccessState) {
            _listNotification.clear();
            _listCheck.clear();
            if (state.list.isNotEmpty) {
              for (var element in state.list) {
                _listNotification.add(element);
                _listCheck.add((element.status == 'READ') ? true : false);
              }
            }
          }
          if (state is NotificationUpdateState) {
            //must be set listCheck index = true. In release mode, task refresh list will be delayed if just wait list refresh.
            _listCheck[state.index] = true;
            // //call event again
            _getEvent(_notificationBloc);
          }
          return (_listNotification.isEmpty)
              ? _buildExceptionNotification('Hiện không có thông báo', context)
              : ListView.builder(
                  padding: EdgeInsets.only(top: 30, bottom: 100),
                  shrinkWrap: true,
                  itemCount: _listNotification.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        if (_listCheck[index] == false)
                          _notificationBloc.add(
                            NotificationEventUpdate(
                              notiId: _listNotification[index].id,
                              index: index,
                              accountId:
                                  AuthenticateHelper.instance.getAccountId(),
                              context: context,
                            ),
                          );
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: _getColorContent(
                              _listNotification[index].keyType,
                              _listCheck[index]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: <Widget>[
                            //
                            Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: 120,
                              alignment: Alignment.center,
                              child: _getNotificationIcon(
                                  _listNotification[index].keyType),
                            ),
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 0.8 - 20,
                              height: 120,
                              child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 25),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${_listNotification[index].typeName}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 3),
                                        ),
                                        Text(
                                          '${_listNotification[index].description}',
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 15,
                                    right: 20,
                                    child: Text(
                                      '${TimeUtil.instance.formatLastMinute(
                                        _listNotification[index].lastMinute,
                                        _listNotification[index].timeCreated,
                                      )}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
        },
      ),
      onRefresh: () async {
        await _getEvent(_notificationBloc);
      },
    );
  }

  _buildExceptionNotification(String msg, BuildContext context) {
    return ListView(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: Image.asset('assets/images/ic-noti.png'),
              ),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              Text(
                '$msg',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
      ],
    );
  }

  _getColorContent(String keyType, bool isRead) {
    return LinearGradient(
      colors: (keyType == NotificationKeyType.KEY_CALENDAR && !isRead)
          ? [
              DefaultTheme.RED_NOTI_1.withOpacity(0.6),
              DefaultTheme.RED_NOTI.withOpacity(0.6),
            ]
          : (keyType == NotificationKeyType.KEY_CONTRACT && !isRead)
              ? [
                  DefaultTheme.BLACK.withOpacity(0.6),
                  DefaultTheme.BLACK.withOpacity(0.6),
                ]
              : (keyType == NotificationKeyType.KEY_VITAL && !isRead)
                  ? [
                      DefaultTheme.GREEN_NOTI_1.withOpacity(0.6),
                      DefaultTheme.GREEN_NOTI.withOpacity(0.6),
                    ]
                  : [
                      DefaultTheme.TRANSPARENT,
                      DefaultTheme.TRANSPARENT,
                    ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  _getNotificationIcon(String keyType) {
    return SizedBox(
      width: 30,
      height: 30,
      child: Image.asset(
        (keyType == NotificationKeyType.KEY_CALENDAR)
            ? 'assets/images/ic-calendar.png'
            : (keyType == NotificationKeyType.KEY_VITAL)
                ? 'assets/images/ic-vital-sign.png'
                : (keyType == NotificationKeyType.KEY_CONTRACT)
                    ? ''
                    : 'assets/images/ic-notification.png',
      ),
    );
  }
}

Future<void> _getEvent(NotificationBloc bloc) async {
  bloc.add(NotificationEventGetList(
      accountId: AuthenticateHelper.instance.getAccountId()));
}

class NotificationKeyType {
  static const String KEY_CALENDAR = 'CALENDAR';
  static const String KEY_CONTRACT = 'CONTRACT';
  static const String KEY_VITAL = 'VITAL_SIGN';
}
