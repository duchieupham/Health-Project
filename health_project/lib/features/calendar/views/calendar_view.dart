import 'package:flutter/material.dart';

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
          children: <Widget>[]),
    );
  }
}
