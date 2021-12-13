import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/widgets/title_widget.dart';

class CalendarView extends StatelessWidget {
  static bool _isInitial = false;
  static final ScrollController _scrollController = ScrollController();
  const CalendarView(Key key) : super(key: key);

  void initialServices(BuildContext context) {
    _isInitial = true;
  }

  _getEvents() {}

  @override
  Widget build(BuildContext context) {
    initialServices(context);
    return RefreshIndicator(
      onRefresh: () async {
        await _getEvents();
      },
      child: ListView(
          key: PageStorageKey('TODAY_LIST'),
          controller: _scrollController,
          padding: EdgeInsets.only(left: 10, right: 10, top: 30),
          children: <Widget>[
            TitleWidget(
              title: 'Sự kiện hôm nay',
              buttonTitle: '',
              color: DefaultTheme.RED_CALENDAR,
              subButton: false,
              onTap: () {},
            ),
            //
            TitleWidget(
              title: 'Sự kiện sắp diễn ra',
              buttonTitle: '',
              color: DefaultTheme.VERY_PERI,
              subButton: false,
              onTap: () {},
            ),
          ]),
    );
  }
}
