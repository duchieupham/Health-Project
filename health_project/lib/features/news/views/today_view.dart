import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/numeral.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/utils/image_util.dart';
import 'package:health_project/commons/utils/time_util.dart';
import 'package:health_project/commons/utils/weather_util.dart';
import 'package:health_project/commons/widgets/title_widget.dart';
import 'package:health_project/features/news/blocs/cat_news_bloc.dart';
import 'package:health_project/features/news/blocs/news_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_project/features/news/blocs/weather_bloc.dart';
import 'package:health_project/features/news/events/cat_news_event.dart';
import 'package:health_project/features/news/events/news_event.dart';
import 'package:health_project/features/news/events/weather_event.dart';
import 'package:health_project/features/news/states/cat_news_state.dart';
import 'package:health_project/features/news/states/news_state.dart';
import 'package:health_project/features/news/states/weather_state.dart';
import 'package:health_project/features/news/views/news_detail_view.dart';
import 'package:health_project/features/news/views/news_list_view.dart';
import 'package:health_project/features/news/views/weather_view.dart';
import 'package:health_project/models/category_news_dto.dart';
import 'package:health_project/models/thumbnail_news_dto.dart';
import 'package:health_project/models/weather_dto.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:health_project/services/authentication_helper.dart';
import 'package:health_project/services/news_page_provider.dart';
import 'package:geolocator/geolocator.dart';

class TodayView extends StatelessWidget {
  const TodayView(Key key) : super(key: key);

  static final List<ThumbnailNewsDTO> _listNews = [];
  static final List<CategoryNewsDTO> _listCategory = [];
  static final ScrollController _scrollController = ScrollController();
  static late final NewsPageProvider _newsPageProvider;
  static late final LastestNewsBloc _lastestNewsBloc;
  static late final CategoryNewsBloc _categoryNewsBloc;
  static late double _maxScrollExtent;
  static late double _currentScroll;
  static bool _isInitial = false;

  void initialServices(BuildContext context) {
    //Call API and initial scroll listener only first time building.
    if (!_isInitial) {
      _lastestNewsBloc = BlocProvider.of(context);
      _categoryNewsBloc = BlocProvider.of(context);
      _newsPageProvider = Provider.of<NewsPageProvider>(context, listen: false);
      _getEvents();
      //
      _scrollController.addListener(() {
        //get max scroll position
        _maxScrollExtent = _scrollController.position.maxScrollExtent;
        //get current scroll position
        _currentScroll = _scrollController.position.pixels;
        //check whether scroll controller scroll to end and list is end.
        if (_maxScrollExtent - _currentScroll == 0 &&
            !_newsPageProvider.hasHomePageEnd) {
          _newsPageProvider.turnNextHomePage();
          _lastestNewsBloc
              .add(NewsEventFetch(page: _newsPageProvider.currentHomePage));
        }
      });
    }
    _isInitial = true;
  }

  @override
  Widget build(BuildContext context) {
    initialServices(context);
    return RefreshIndicator(
      child: ListView(
        key: PageStorageKey('TODAY_LIST'),
        controller: _scrollController,
        padding: EdgeInsets.only(left: 10, right: 10, top: 30),
        children: <Widget>[
          //weather
          TitleWidget(
            title: 'Thời tiết',
            buttonTitle: '',
            color: DefaultTheme.BLUE_TEXT,
            subButton: false,
            onTap: null,
          ),
          _buildWeather(context),
          Padding(padding: EdgeInsets.only(bottom: 20)),
          //category
          TitleWidget(
            title: 'Danh mục',
            buttonTitle: '',
            color: DefaultTheme.NEON,
            subButton: false,
            onTap: null,
          ),
          _buildCategory(context),
          Padding(padding: EdgeInsets.only(bottom: 20)),
          //lastest news widget
          TitleWidget(
            title:
                'Bản tin dành cho ${AuthenticateHelper.instance.getFirstName()}',
            buttonTitle: '',
            color: Theme.of(context).indicatorColor,
            subButton: false,
            onTap: null,
          ),
          _buildLastedNews(context),
          //footer
          Padding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
      onRefresh: () async {
        await _getEvents();
      },
    );
  }

  Widget _buildWeather(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(bottom: 20, top: 20, left: 10, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: WeatherUtil.instance.getBackgroundWidget(),
            colorFilter: ColorFilter.mode(
              DefaultTheme.BLACK.withOpacity(0.1),
              BlendMode.hardLight,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: (state is WeatherSuccessState)
            ? _buildWeatherSuccessState(context, state.weatherDTO)
            : (state is WeatherLoadingState)
                ? _buildWeatherLoadingState(context)
                : _buildWeatherOtherState(context, state),
      );
    });
  }

  Widget _buildWeatherSuccessState(BuildContext context, WeatherDTO dto) {
    String WEATHER_TAG = 'WEATHER';
    //get weather from Forecast.io
    ConsolidatedWeather consolidatedWeather = dto.consolidatedWeather[1];
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => WeatherView(
                weatherDTO: dto,
              ),
              transitionDuration: Duration(milliseconds: 500),
            )).then((value) {
          WEATHER_TAG = value;
        });
      },
      child: Hero(
        tag: WEATHER_TAG,
        child: Row(
          children: [
            Image.asset(
              WeatherUtil.instance.getUrlIconByWeatherState(
                  consolidatedWeather.weatherStateAbbr),
              width: 40,
              height: 40,
            ),
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12,
                ),
                children: [
                  TextSpan(
                    text: '${dto.title}\n',
                    style: TextStyle(
                      color: DefaultTheme.WHITE,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text:
                        '${WeatherUtil.instance.getWeatherDescription(consolidatedWeather.weatherStateAbbr)}',
                    style: TextStyle(
                      color: DefaultTheme.WHITE,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 10)),
            Spacer(),
            Text(
              '${consolidatedWeather.theTemp.toInt()}\u2103',
              style: TextStyle(
                color: DefaultTheme.WHITE,
                fontSize: 25,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherLoadingState(BuildContext contexy) {
    return Row(
      children: [
        Image.asset(
          'assets/images/ic-heavy-cloud.png',
          width: 40,
          height: 40,
        ),
        //Spacer(),
        Text(
          'Đang tải dữ liệu thời tiết',
          style: TextStyle(
            color: DefaultTheme.WHITE,
          ),
        ),
        Spacer(),
        Text(
          '--',
          style: TextStyle(
            color: DefaultTheme.WHITE,
            fontSize: 25,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherOtherState(BuildContext context, WeatherState state) {
    final WeatherBloc _weatherBloc = BlocProvider.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 5, right: 5),
          margin: EdgeInsets.only(bottom: 10),
          child: Text(
            _getWeatherMsg(state),
            style: TextStyle(
              color: DefaultTheme.WHITE,
              fontSize: 15,
            ),
          ),
        ),
        (state is WeatherFailedState)
            ? _buildButtonWeather(
                context, MediaQuery.of(context).size.width, 'Tải lại',
                onTap: () {
                _weatherBloc.add(WeatherGetEvent());
              })
            : Row(
                children: [
                  _buildButtonWeather(
                    context,
                    (MediaQuery.of(context).size.width / 2) - 30,
                    'Tải lại',
                    onTap: () {
                      _weatherBloc.add(WeatherGetEvent());
                    },
                  ),
                  Spacer(),
                  _buildButtonWeather(
                    context,
                    (MediaQuery.of(context).size.width / 2) - 30,
                    'Cài đặt',
                    onTap: () async {
                      if (state is WeatherRequestPermissionState ||
                          state is WeatherDenyPermissionState) {
                        await Geolocator.openAppSettings();
                      } else if (state is WeatherDisableState) {
                        await Geolocator.openLocationSettings();
                      }
                    },
                  ),
                ],
              )
      ],
    );
  }

  Widget _buildCategory(BuildContext context) {
    return BlocConsumer<CategoryNewsBloc, CategoryNewsState>(
      listener: (context, state) {
        if (state is CategoryNewsSuccessState) {
          _listCategory.addAll(state.list);
        }
      },
      builder: (context, state) {
        return (_listCategory.isNotEmpty)
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: ListView.builder(
                  key: PageStorageKey('LIST_CATEGORY'),
                  scrollDirection: Axis.horizontal,
                  itemCount: _listCategory.length,
                  itemBuilder: (BuildContext context, int index) {
                    String typeNameHero = _listCategory[index].typeName;
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  NewsListView(
                                categoryDTO: _listCategory[index],
                              ),
                              transitionDuration: Duration(milliseconds: 300),
                            )).then((value) {
                          typeNameHero = value;
                        });
                      },
                      child: Hero(
                        tag: typeNameHero,
                        child: Container(
                          width: 200,
                          height: 100,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                DefaultTheme.BLACK.withOpacity(0.4),
                                BlendMode.hardLight,
                              ),
                              fit: BoxFit.cover,
                              image: ImageUtil.instance
                                  .getImageNetWork(_listCategory[index].image),
                            ),
                          ),
                          child: Text(
                            '${_listCategory[index].typeName}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: DefaultTheme.WHITE,
                              fontFamily: 'NewYork',
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            : Container();
      },
    );
  }

  Widget _buildLastedNews(BuildContext context) {
    return BlocConsumer<LastestNewsBloc, NewsState>(
      //Use listener because of having Provider for update UI.
      //Provider cannot notifyListener() in builder.
      listener: (context, state) {
        if (state is LastedNewsSuccessState) {
          //Because when list is on initial/refresh state, it's empty.
          //Check list whether is empty for reset pagging.
          if (_listNews.isEmpty) {
            _newsPageProvider.updateHomePageEnd(false);
          }
          //add all item when list isn't end
          if (!_newsPageProvider.hasHomePageEnd) _listNews.addAll(state.list);
          //update variable when list is end
          if (state.list.length < DefaultNumeral.ROW_LOADING) {
            _newsPageProvider.updateHomePageEnd(true);
            //Make sure after end of page, user refresh and reload 1st page.
            _newsPageProvider.prevToFirstHomePage();
          }
        }
      },
      builder: (context, state) {
        if (state is LastedNewsLoadingState) {
          return _buildLoadingNews(context);
        }
        return (_listNews.isNotEmpty)
            ? ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                key: PageStorageKey('LIST_NEWS'),
                itemCount: (_newsPageProvider.hasHomePageEnd)
                    ? _listNews.length
                    : _listNews.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10, top: 5),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      child: (index == 0)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.width * 1 / 2,
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: ImageUtil.instance.getImageNetWork(
                                          _listNews[index].image),
                                    ),
                                  ),
                                ),
                                RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'NewYork',
                                    ),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text:
                                            '${TimeUtil.instance.formatLastMinute(_listNews[index].lastMinute, _listNews[index].timeCreated)}\t',
                                        style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10),
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${_listNews[index].actor}',
                                        style: TextStyle(
                                          color:
                                              Theme.of(context).indicatorColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                ),
                                Text(
                                  '${_listNews[index].title}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'NewYork',
                                    letterSpacing: 0.3,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ],
                            )
                          : (index == _listNews.length)
                              ? Image.asset(
                                  'assets/images/loading-news.png',
                                  width: MediaQuery.of(context).size.width,
                                )
                              : Row(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: ImageUtil.instance
                                              .getImageNetWork(
                                                  _listNews[index].image),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                              0.6 -
                                          20,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.3,
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        bottom: 5,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${_listNews[index].title}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'NewYork',
                                              letterSpacing: 0.3,
                                              height: 1.25,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 4,
                                          ),
                                          RichText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            text: TextSpan(
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'NewYork',
                                              ),
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text:
                                                      '${TimeUtil.instance.formatLastMinute(_listNews[index].lastMinute, _listNews[index].timeCreated)}\t',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                ),
                                                WidgetSpan(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${_listNews[index].actor}',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .indicatorColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                      onTap: () {
                        _navigateToNewsDetail(
                          _listNews[index].catId,
                          _listNews[index].newsId,
                          context,
                        );
                      },
                    ),
                  );
                },
              )
            : Container();
      },
    );
  }

  Widget _buildLoadingNews(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Image.asset(
        'assets/images/loading-newsfeed.png',
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget _buildButtonWeather(BuildContext context, double width, String name,
      {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: DefaultTheme.WHITE.withOpacity(0.6),
        ),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(color: DefaultTheme.BLACK),
        ),
      ),
    );
  }

  //get APIs from server
  _getEvents() {
    _listNews.clear();
    _listCategory.clear();
    _lastestNewsBloc
        .add(NewsEventFetch(page: _newsPageProvider.currentHomePage));
    _categoryNewsBloc.add(CategoryNewsEventGet());
  }

  void _navigateToNewsDetail(int catId, int newsId, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewsDetailView(
                  newsId: newsId,
                  catId: catId,
                )));
  }

  String _getWeatherMsg(WeatherState state) {
    String msg = '';
    if (state is WeatherDisableState) {
      msg = 'Dịch vụ định vị đang tắt.\nVui lòng mở lại trong cài đặt.';
    } else if (state is WeatherRequestPermissionState) {
      msg =
          'Vui lòng cho phép Health Project truy cập vị trí để chúng tôi cập nhật thời tiết trong khu vực.';
    } else if (state is WeatherDenyPermissionState) {
      msg =
          'Vui lòng bật quyền truy cập dịch vụ định vị để chúng tối cập nhật thời tiết trong khu vực.';
    } else if (state is WeatherFailedState) {
      msg = 'Không thể tải thông tin thời tiết.';
    }
    return msg;
  }
}
