import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/utils/time_util.dart';
import 'package:health_project/features/calendar/blocs/calendar_bloc.dart';
import 'package:health_project/features/calendar/events/calendar_event.dart';
import 'package:health_project/features/calendar/states/calendar_state.dart';
import 'package:health_project/models/event_dto.dart';
import 'package:health_project/services/authentication_helper.dart';
import 'package:provider/provider.dart';
import 'package:health_project/services/calendar_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:rive/rive.dart' as rive;

class CalendarView extends StatefulWidget {
  const CalendarView(Key key) : super(key: key);

  @override
  _CalendarView createState() => _CalendarView();
}

class _CalendarView extends State<CalendarView> {
  //provider
  late final CalendarProvider _calendarProvider;
  //bloc
  late final CalendarBloc _calendarBloc;

  //animation
  bool _valueChange = false;
  bool _isInitializeRive = false;
  String _animationDefault = 'Keep notify';
  //late rive.SMIBool _action;

  //animation controller
  //late rive.StateMachineController _riveController;

  //calendar controller
  final PageController _calendarController = PageController(
    initialPage: int.tryParse(
            DateFormat.M(Locale('vi').countryCode).format(DateTime.now()))! -
        1,
    viewportFraction: 0.35,
  );

  //variables of event in calendar
  List<EventDTO> _selectedEvent = [];
  final Map<DateTime, List<EventDTO>> _listMapped = {};

  //format date
  final DateFormat _formatter = DateFormat('yyyy-MM-dd');

  //
  @override
  void initState() {
    super.initState();
    // _calendarProvider = Provider.of<CalendarProvider>(context, listen: false);
    // _calendarBloc = BlocProvider.of(context);
    // _calendarBloc.add(CalendarEventCheck(AuthenticateHelper.instance.getAccountId()));
    // _animationDefault = (_valueChange) ? 'Keep notify' : 'Keep slient';
  }

  @override
  void dispose() {
    // _calendarController.dispose();
    // if (_isInitializeRive) _riveController.dispose();
    super.dispose();
  }

  // _onRiveInit(rive.Artboard artboard) {
  //   _riveController =
  //       rive.StateMachineController.fromArtboard(artboard, 'Bell Animation')!;
  //   artboard.addController(_riveController);
  //   _action = _riveController.findInput<bool>('isNotify') as rive.SMIBool;
  //   _action.change(_valueChange);
  //   _isInitializeRive = true;
  // }

  // _changeAniamtionEventStatus() {
  //   _valueChange = !_valueChange;
  //   _action.change(_valueChange);
  // }

  _getListMapped() {
    if (_selectedEvent.isNotEmpty) {
      _selectedEvent.forEach((element) {
        _listMapped[_formatter.parse(element.timeEvent)] = _selectedEvent
            .where((item) =>
                _formatter.parse(item.timeEvent) ==
                _formatter.parse(element.timeEvent))
            .toList();
      });
    }
  }

  _getEventsForDay(DateTime date) {
    if (_listMapped.isEmpty) return [];
    if (_listMapped.containsKey(_formatter.parse(date.toString()))) {
      return _listMapped[_formatter.parse(date.toString())];
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // return ClipRRect(
    //   borderRadius: BorderRadius.circular(33.33),
    //   child: ListView(
    //     padding: EdgeInsets.all(0),
    //     children: <Widget>[
    //       //
    //       BlocBuilder<CalendarBloc, CalendarState>(
    //         builder: (context, state) {
    //           if (state is CalendarSuccessState) {
    //             _selectedEvent = state.list!;
    //           }
    //           _getListMapped();
    //           return Container(
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(33.33),
    //               image: DecorationImage(
    //                 fit: BoxFit.contain,
    //                 repeat: ImageRepeat.repeatY,
    //                 alignment: Alignment.topCenter,
    //                 image: AssetImage('assets/images/bg-calendar.png'),
    //               ),
    //             ),
    //             child: Column(
    //               children: <Widget>[
    //                 _buildCalendar(),
    //                 _buildSchedule(),
    //                 _buildFootPadding(),
    //               ],
    //             ),
    //           );
    //         },
    //       ),
    //     ],
    //   ),
    // );

    return Container();
  }

  _buildCalendar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              height: MediaQuery.of(context).size.height * 0.45,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(33.33),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.45,
                    color: Theme.of(context).buttonColor.withOpacity(0.4),
                  ),
                ),
              ),
            ),
            left: 10,
            top: 110,
          ),
          Container(
              margin: EdgeInsets.only(top: 120),
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Consumer<CalendarDateProvider>(
                builder: (context, dateProvider, child) {
                  return TableCalendar(
                    locale: 'vi-VN',
                    firstDay: DateTime.utc(2015, 01, 01),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: dateProvider.focusedDay,
                    headerVisible: false,
                    daysOfWeekHeight: 50,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: null,
                        fontWeight: FontWeight.w500,
                      ),
                      weekendStyle: TextStyle(
                        color: null,
                        fontWeight: FontWeight.w500,
                      ),
                      dowTextFormatter: (date, locale) => TimeUtil.instance
                          .formatDateOfWeekCalendar(
                              DateFormat.E(locale).format(date)),
                    ),
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: true,
                      isTodayHighlighted: true,
                      todayDecoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            DefaultTheme.LIGHT_PURPLE.withOpacity(0.6),
                            DefaultTheme.BLUE_TEXT.withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      markersMaxCount: 1,
                      markerSize: 6,
                      markerDecoration: BoxDecoration(
                        color: DefaultTheme.NEON,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            DefaultTheme.LIGHT_PINK,
                            DefaultTheme.DARK_PURPLE,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      outsideTextStyle:
                          TextStyle(color: Theme.of(context).accentColor),
                      weekendTextStyle: TextStyle(
                        color: null,
                      ),
                    ),
                    selectedDayPredicate: (day) {
                      return isSameDay(dateProvider.selectedDay, day);
                    },
                    onPageChanged: (_) {
                      _calendarProvider.updateTime(_);
                      _calendarController.animateToPage(
                        _calendarProvider.currentMonth - 1,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeInToLinear,
                      );
                    },
                    onDaySelected: (selectedDay, focusedDay) => dateProvider
                        .updateSelectedAndFocusedDay(selectedDay, focusedDay),
                    eventLoader: (day) => _getEventsForDay(day),
                  );
                },
              )),
          Positioned(
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              height: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(33.33),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 90,
                    color: Theme.of(context).buttonColor.withOpacity(0.4),
                    padding: EdgeInsets.only(
                      left: 8,
                      right: 8,
                    ),
                    child: Consumer<CalendarProvider>(
                      builder: (context, calendar, child) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 5),
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                              alignment: Alignment.bottomCenter,
                              child: PageView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 12,
                                controller: _calendarController,
                                itemBuilder: (context, index) {
                                  return Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      TimeUtil.instance
                                          .formatMonthCalendar('${index + 1}'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: ((calendar.currentMonth - 1) ==
                                                index)
                                            ? null
                                            : Theme.of(context).accentColor,
                                        fontSize:
                                            ((calendar.currentMonth - 1) ==
                                                    index)
                                                ? 15
                                                : 12,
                                        fontWeight:
                                            ((calendar.currentMonth - 1) ==
                                                    index)
                                                ? FontWeight.w500
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              //margin: EdgeInsets.only(top: 15),
                              width: MediaQuery.of(context).size.width,
                              height: 15,
                              alignment: Alignment.topCenter,
                              child: Text(
                                '${calendar.currentYear}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).indicatorColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            left: 10,
            top: 10,
          ),
        ],
      ),
    );
  }

  _buildSchedule() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 10, right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(33.33),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 25,
            sigmaY: 25,
          ),
          child: Container(
              width: MediaQuery.of(context).size.width,
              padding:
                  EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
              color: Theme.of(context).buttonColor.withOpacity(0.4),
              child: Consumer<CalendarDateProvider>(
                builder: (context, dateProvider, child) {
                  List<EventDTO>? listEvent = _listMapped[
                      _formatter.parse(dateProvider.selectedDay.toString())];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 120,
                        height: 120,
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              dateProvider.getCurrentDayOfWeek(),
                              style: TextStyle(
                                color: Theme.of(context).indicatorColor,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              dateProvider.getCurrentDate(),
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            (listEvent != null)
                                ? Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      '${listEvent.length} sự kiện',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                      (listEvent != null)
                          ? _buildListEvent(_listMapped[_formatter
                              .parse(dateProvider.selectedDay.toString())]!)
                          : _buildEmptyEvent(),
                    ],
                  );
                },
              )),
        ),
      ),
    );
  }

  _buildListEvent(List<EventDTO> listEvent) {
    return Container(
      width: MediaQuery.of(context).size.width - 160,
      margin: EdgeInsets.only(top: 10),
      child: ListView.builder(
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: listEvent.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                _buildEventDetail(listEvent[index]);
              },
              child: Container(
                padding: EdgeInsets.only(bottom: 3, top: 3, left: 5),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 3,
                      color: DefaultTheme.NEON,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${listEvent[index].title}',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${TimeUtil.instance.formatHour(listEvent[index].timeEvent)}',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  _buildEmptyEvent() {
    return Container(
      width: MediaQuery.of(context).size.width - 160,
      height: 120,
      child: Center(
        child: Text(
          'Không có sự kiện trong ngày',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }

  _buildFootPadding() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
    );
  }

  _buildEventDetail(EventDTO eventDTO) {
    return showModalBottomSheet(
      isScrollControlled: false,
      context: this.context,
      backgroundColor: DefaultTheme.TRANSPARENT,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: ClipRRect(
            child: Padding(
              padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
              child: Container(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 30,
                  bottom: 10,
                ),
                width: MediaQuery.of(context).size.width - 10,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(33.33),
                  color: Theme.of(context).buttonColor.withOpacity(0.95),
                ),
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: ListView(
                            children: <Widget>[
                              Text(
                                  '${TimeUtil.instance.formatDateEvent(eventDTO.timeEvent)}'),
                              Container(
                                margin: EdgeInsets.only(
                                  right:
                                      MediaQuery.of(context).size.width * 0.2,
                                  top: 3,
                                ),
                                child: Text(
                                  '${eventDTO.title}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 10, bottom: 30),
                                child: Text(
                                  '${TimeUtil.instance.formatHour(eventDTO.timeEvent)}',
                                  style: TextStyle(
                                    color: Theme.of(context).indicatorColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              (eventDTO.content != '')
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Nội dung',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 5)),
                                        Text(
                                          '${eventDTO.content}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 30)),
                                      ],
                                    )
                                  : Container(),
                              Text(
                                'Người tạo',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 5)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: DefaultTheme.GREY_VIEW,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                  Padding(padding: EdgeInsets.only(right: 20)),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${eventDTO.dlastname} ${eventDTO.dfirstname}',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        '${eventDTO.phone}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context).accentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Icon(
                                    CupertinoIcons.exclamationmark_circle,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Positioned(
                    //   child: Container(
                    //     width: 40,
                    //     height: 40,
                    //     padding: EdgeInsets.all(5),
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(40),
                    //       color: Theme.of(context).hoverColor,
                    //     ),
                    //     child: GestureDetector(
                    //       child: rive.RiveAnimation.asset(
                    //         'assets/rives/bell.riv',
                    //         fit: BoxFit.cover,
                    //         animations: [_animationDefault],
                    //         onInit: _onRiveInit,
                    //       ),
                    //       onTap: _changeAniamtionEventStatus,
                    //     ),
                    //   ),
                    //   right: 10,
                    // )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
