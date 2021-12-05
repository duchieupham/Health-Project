import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/numeral.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/routes/routes.dart';
import 'package:health_project/commons/utils/image_util.dart';
import 'package:health_project/commons/utils/time_util.dart';
import 'package:health_project/features/calendar/views/calendar_view.dart';
import 'package:health_project/features/health/views/health_view.dart';
import 'package:health_project/features/news/blocs/weather_bloc.dart';
import 'package:health_project/features/news/events/weather_event.dart';
import 'package:health_project/features/news/views/today_view.dart';
import 'package:health_project/features/notification/blocs/notification_bloc.dart';
import 'package:health_project/features/notification/events/notification_event.dart';
import 'package:health_project/features/notification/views/notification_view.dart';
import 'package:health_project/services/authentication_helper.dart';
import 'package:health_project/services/notification_count_provider.dart';
import 'package:health_project/services/page_select_provider.dart';
import 'package:health_project/services/peripheral_helper.dart';
import 'package:health_project/services/theme_helper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeView extends StatelessWidget {
  //
  const HomeView();

  //page controller
  static final PageController _pageController = PageController(
    initialPage: DefaultNumeral.INITIAL_PAGE,
    keepPage: true,
  );
  //
  //list page
  static const List<Widget> _homeScreens = [
    const CalendarView(PageStorageKey('CAL_VIEW')),
    const TodayView(PageStorageKey('TODAY_VIEW')),
    const HealthView(PageStorageKey('HEALTH_VIEW')),
    const NotificationView(PageStorageKey('NOTI_VIEW')),
  ];

  //check initial
  static bool _isInit = false;

  void initialServices(BuildContext context) {
    NotificationBloc _notificationBloc = BlocProvider.of(context);
    WeatherBloc _weatherBloc = BlocProvider.of(context);
    _notificationBloc.add(NotificationEventGetUnreadCount(
        accountId: AuthenticateHelper.instance.getAccountId(),
        context: context));
    _weatherBloc.add(WeatherGetEvent());
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInit) initialServices(context);
    _isInit = true;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          //body
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: PageView(
              key: PageStorageKey('PAGE_VIEW'),
              allowImplicitScrolling: true,
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                Provider.of<PageSelectProvider>(context, listen: false)
                    .updateIndex(index);
              },
              children: _homeScreens,
            ),
          ),
          //header
          Container(
            width: MediaQuery.of(context).size.width,
            height: 65,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 25,
                  sigmaY: 25,
                ),
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Consumer<PageSelectProvider>(
                          builder: (context, page, child) {
                        return Text(
                          _getTitlePaqe(context, page.indexSelected),
                          style: TextStyle(
                            fontFamily: 'NewYork',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        );
                      }),
                      Spacer(),
                      // Container(
                      //   width: 50,
                      //   height: 50,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(25),
                      //     border: Border.all(
                      //         width: 0.25, color: DefaultTheme.GREY_TEXT),
                      //     image: DecorationImage(
                      //       image: (AuthenticateHelper.instance.getAvatar() != '')
                      //           ? ImageUtil.instance.getImageNetWork(
                      //               AuthenticateHelper.instance.getAvatar())
                      //           : Image.asset('assets/images/avatar-default.jpg')
                      //               .image,
                      //     ),
                      //   ),
                      //   child:
                      InkWell(
                        onTap: () {
                          _buildSetting(context);
                        },
                        child: (AuthenticateHelper.instance.getAvatar() == '')
                            ? _getDefaultAvatar(context, 50, 0, 0)
                            : _getAvatar(context, 50, 0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              alignment: Alignment.center,
              height: 70,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
                boxShadow: [
                  BoxShadow(
                    color: DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(2, 2),
                  ),
                ],
                borderRadius: BorderRadius.circular(25),
              ),
              width: MediaQuery.of(context).size.width * 0.75,
              child: Stack(
                children: [
                  Consumer<PageSelectProvider>(
                    builder: (context, page, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _buildShortcut(
                            0,
                            page.indexSelected,
                            context,
                          ),
                          _buildShortcut(
                            1,
                            page.indexSelected,
                            context,
                          ),
                          _buildShortcut(
                            2,
                            page.indexSelected,
                            context,
                          ),
                          _buildShortcut(
                            3,
                            page.indexSelected,
                            context,
                          ),
                        ],
                      );
                    },
                  ),
                  Positioned(
                    child: Consumer<NotificationCountProvider>(
                      builder: (context, count, child) {
                        return (count.count != 0)
                            ? Container(
                                alignment: Alignment.center,
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      DefaultTheme.LIGHT_PINK,
                                      DefaultTheme.RED_CALENDAR,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${count.count}',
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: DefaultTheme.WHITE,
                                    fontSize: 10,
                                  ),
                                ),
                              )
                            : Container();
                      },
                    ),
                    right: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    //   },
    // );
  }

//build shorcuts in bottom bar
  _buildShortcut(int index, int indexSelected, BuildContext context) {
    bool isSelected = (index == indexSelected);
    return InkWell(
      onTap: () {
        _animatedToPage(index);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: (isSelected)
              ? Theme.of(context).hoverColor
              : DefaultTheme.TRANSPARENT,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Image.asset(
          _getAssetIcon(index, isSelected),
          width: 35,
          height: 35,
        ),
      ),
    );
  }

  _buildSetting(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
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
                  top: 10,
                ),
                width: MediaQuery.of(context).size.width - 10,
                height: MediaQuery.of(context).size.height * 0.7,
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
                    (AuthenticateHelper.instance.getAvatar() == '')
                        ? _getDefaultAvatar(context, 65, 20, 8)
                        : _getAvatar(context, 65, 20, 8),
                    Flexible(
                      child: Text(
                        AuthenticateHelper.instance.getFirstNameAndLastName(),
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      margin: EdgeInsets.only(top: 30),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      decoration: DefaultTheme.cardDecoration(context),
                      child: ListView(
                        padding: EdgeInsets.only(bottom: 5, top: 5),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          //
                          _buildItemList(
                            context,
                            'assets/images/ic-information.png',
                            'Thông tin tài khoản',
                            false,
                            '',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, Routes.INFOR_VIEW);
                            },
                          ),
                          _buildItemList(
                            context,
                            'assets/images/ic-device.png',
                            'Thiết bị đeo',
                            true,
                            (PeripheralHelper.instance.isPeripheralConnect())
                                ? 'Đã kết nối'
                                : 'Chưa kết nối',
                            onTap: () {
                              Navigator.pop(context);
                              if (PeripheralHelper.instance
                                  .isPeripheralConnect()) {
                                Navigator.pushNamed(
                                    context, Routes.PERIPHERAL_INFOR_VIEW);
                              } else {
                                Navigator.of(context)
                                    .pushNamed(Routes.INTRO_CONNECT_VIEW);
                              }
                            },
                          ),
                          _buildItemList(
                            context,
                            'assets/images/ic-theme.png',
                            'Giao diện',
                            true,
                            _formatThemeText(ThemeHelper.instance.getTheme()),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                  context, Routes.SETTING_THEME);
                            },
                          ),
                        ],
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 50,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      margin: EdgeInsets.only(bottom: 10),
                      alignment: Alignment.center,
                      decoration: DefaultTheme.cardDecoration(context),
                      child: Text(
                        'Đăng xuất',
                        style: TextStyle(
                          color: DefaultTheme.RED_TEXT,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //build button item in setting view
  Widget _buildItemList(BuildContext context, String imageAsset, String title,
      bool isStatusShow, String statusMsg,
      {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 0.25,
                  color: DefaultTheme.GREY_LIGHT,
                ),
                image: DecorationImage(
                  image: AssetImage(imageAsset),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacer(),
            (isStatusShow)
                ? Container(
                    child: Text(
                      statusMsg,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Image.asset(
                'assets/images/ic-gointo.png',
                width: 15,
                height: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getAvatar(BuildContext context, double radius, double marginTop,
      double marginBottom) {
    return CachedNetworkImage(
      httpHeaders: ImageUtil.instance.getHeaderImage(),
      imageUrl: ImageUtil.instance
          .getImageUrl(AuthenticateHelper.instance.getAvatar()),
      imageBuilder: (context, imageProvider) => Container(
        width: radius,
        height: radius,
        margin: EdgeInsets.only(top: marginTop, bottom: marginBottom),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(65),
          border: Border.all(width: 0.25, color: DefaultTheme.GREY_TEXT),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      errorWidget: (context, url, error) =>
          _getDefaultAvatar(context, radius, marginTop, marginBottom),
    );
  }

  Widget _getDefaultAvatar(BuildContext context, double radius,
      double marginTop, double marginBottom) {
    return Container(
      width: radius,
      height: radius,
      margin: EdgeInsets.only(top: marginTop, bottom: marginBottom),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(65),
        border: Border.all(width: 0.25, color: DefaultTheme.GREY_TEXT),
        image: DecorationImage(
          image: AssetImage('assets/images/avatar-default.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  //get title page
  String _getTitlePaqe(BuildContext context, int indexSelected) {
    String title = '';
    if (indexSelected == 0) {
      title = 'Lịch';
    }
    if (indexSelected == 1) {
      title =
          '${TimeUtil.instance.getCurrentDateInWeek()}\n${TimeUtil.instance.getCurentDate()}';
    }
    if (indexSelected == 2) {
      title = 'Sức khoẻ';
    }
    if (indexSelected == 3) {
      title = 'Thông báo';
    }
    return title;
  }

  //get image assets
  String _getAssetIcon(int index, bool isSelected) {
    final String prefix = 'assets/images/';
    String assetImage = (index == 0 && isSelected)
        ? 'ic-calendar.png'
        : (index == 0 && !isSelected)
            ? 'ic-calendar-u.png'
            : (index == 1 && isSelected)
                ? 'ic-dashboard.png'
                : (index == 1 && !isSelected)
                    ? 'ic-dashboard-u.png'
                    : (index == 2 && isSelected)
                        ? 'ic-vital-sign.png'
                        : (index == 2 && !isSelected)
                            ? 'ic-vital-sign-u.png'
                            : (index == 3 && isSelected)
                                ? 'ic-noti.png'
                                : 'ic-noti-u.png';
    return '$prefix$assetImage';
  }

  //navigate to page
  void _animatedToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOutQuart,
    );
  }

  //format theme description
  String _formatThemeText(String theme) {
    String result = '';
    if (theme == DefaultTheme.THEME_SYSTEM)
      result = 'Hệ thống';
    else if (theme == DefaultTheme.THEME_LIGHT)
      result = 'Sáng';
    else if (theme == DefaultTheme.THEME_DARK) result = 'Tối';
    return result;
  }
}
