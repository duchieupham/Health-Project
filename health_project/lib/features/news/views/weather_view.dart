import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/utils/time_util.dart';
import 'package:health_project/commons/utils/weather_util.dart';
import 'package:health_project/commons/widgets/compass_painter.dart';
import 'package:health_project/commons/widgets/dotted_line_painter.dart';
import 'package:health_project/commons/widgets/ruler_painter.dart';
import 'package:health_project/commons/widgets/textfield_widget.dart';
import 'package:health_project/features/news/blocs/weather_bloc.dart';
import 'package:health_project/features/news/events/weather_event.dart';
import 'package:health_project/features/news/states/weather_state.dart';
import 'package:health_project/models/weather_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherView extends StatefulWidget {
  final WeatherDTO weatherDTO;

  const WeatherView({required this.weatherDTO});

  @override
  State<StatefulWidget> createState() => _WeatherView(weatherDTO: weatherDTO);
}

class _WeatherView extends State<WeatherView>
    with SingleTickerProviderStateMixin {
  //
  final WeatherDTO weatherDTO;
  static const String WEATHER_TAG = 'WEATHER';
  late final ConsolidatedWeather _consolidatedWeather;
  late double _boxEdge;
  final double _blur = 25;

  //weather search bloc
  late final WeatherSearchBloc _weatherSearchBloc;

  //for wind compass _animation
  late Animation<double> _animation;
  late AnimationController _animationController;

  //search controller
  final TextEditingController _searchController = TextEditingController();
  bool _isClearSearch = false;

  //
  @override
  _WeatherView({required this.weatherDTO});

  @override
  void initState() {
    super.initState();
    _weatherSearchBloc = BlocProvider.of(context);
    //get weather from Forecast.io
    _consolidatedWeather = weatherDTO.consolidatedWeather[1];
    //
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _boxEdge = (MediaQuery.of(context).size.width / 2) - 30 - 20;
    return WillPopScope(
        child: Scaffold(
          backgroundColor: WeatherUtil.instance.getWeatherBackgroundColor(),
          body: Stack(
            children: [
              Hero(
                tag: WEATHER_TAG,
                child: WeatherUtil.instance.getBackgroundWeatherImage(context),
              ),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 180,
                    alignment: Alignment.center,
                    child: Image.asset(
                      WeatherUtil.instance.getUrlIconByWeatherState(
                          _consolidatedWeather.weatherStateAbbr),
                      width: 120,
                      height: 120,
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<WeatherSearchBloc, WeatherState>(
                      builder: (context, state) {
                        return ListView(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          children: [
                            _buildBoxWidget(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              padding: 0,
                              marginTop: 0,
                              blur: _blur,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                  ),
                                  Flexible(
                                    child: TextFieldHDr(
                                      style: TFStyle.NO_BORDER,
                                      controller: _searchController,
                                      capitalStyle: TextCapitalization.none,
                                      labelTextWidth: 0,
                                      placeHolder: 'Tìm tên Thành Phố',
                                      inputType: TFInputType.TF_TEXT,
                                      keyboardAction: TextInputAction.done,
                                      onChange: (text) {
                                        if (text.toString().length >= 2) {
                                          _isClearSearch = true;
                                          _weatherSearchBloc.add(
                                            WeatherSearchEvent(
                                                keyword:
                                                    _searchController.text),
                                          );
                                        } else {
                                          _isClearSearch = false;
                                          _weatherSearchBloc
                                              .add(WeatherClearSearchEvent());
                                        }
                                      },
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (_isClearSearch) {
                                        _isClearSearch = false;
                                        _weatherSearchBloc
                                            .add(WeatherClearSearchEvent());
                                        _searchController.clear();
                                        FocusScope.of(context).unfocus();
                                      } else {
                                        if (_searchController.text.isNotEmpty) {
                                          _isClearSearch = true;
                                          _weatherSearchBloc.add(
                                            WeatherSearchEvent(
                                                keyword:
                                                    _searchController.text),
                                          );
                                        }
                                      }
                                    },
                                    child: Image.asset(
                                      (_isClearSearch)
                                          ? 'assets/images/ic-close.png'
                                          : 'assets/images/ic-search.png',
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                  ),
                                ],
                              ),
                            ),
                            (state is WeatherSearchLoadingState)
                                ? _buildLoadingWeatherWidget(blur: _blur)
                                : (state is WeatherClearSearchState)
                                    ? _buildWeatherWidget(
                                        consolidatedWeather:
                                            _consolidatedWeather,
                                        locationName: weatherDTO.title,
                                        sourceName: weatherDTO.sources[1].title,
                                        sunrise: weatherDTO.sunRise,
                                        sunset: weatherDTO.sunSet,
                                        blur: _blur,
                                      )
                                    : (state is WeatherSearchSuccessState &&
                                            state.list.isNotEmpty)
                                        ? _buildBoxWidget(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: null,
                                            padding: 20,
                                            marginTop: 20,
                                            blur: _blur,
                                            child: ListView.separated(
                                              padding: EdgeInsets.all(0),
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: state.list.length,
                                              separatorBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      const Divider(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return InkWell(
                                                  onTap: () {
                                                    _weatherSearchBloc.add(
                                                      WeatherAccessLocationEvent(
                                                        woeid: state
                                                            .list[index].woeid,
                                                      ),
                                                    );
                                                    _buildAccessWeatherWidget();
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Text(
                                                      '${state.list[index].title}',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : (state is WeatherSearchEmptyState)
                                            ? _buildBoxWidget(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: null,
                                                padding: 20,
                                                marginTop: 20,
                                                blur: _blur,
                                                child: Text(
                                                  'Không có kết quả tìm kiếm cho "${_searchController.text.trim()}"',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              )
                                            : Container(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 50,
                right: 20,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.pop(context, WEATHER_TAG);
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: DefaultTheme.BLACK_BUTTON.withOpacity(0.6),
                    ),
                    child: Image.asset('assets/images/ic-close-white.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
        onWillPop: () async {
          Navigator.pop(context, 'WEATHER');
          return true;
        });
  }

  _buildAccessWeatherWidget() {
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
                height: MediaQuery.of(context).size.height * 0.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(33.33),
                  color: WeatherUtil.instance.getWeatherBackgroundColor(),
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
                    Expanded(
                      child: SingleChildScrollView(
                        child: BlocBuilder<WeatherSearchBloc, WeatherState>(
                          builder: (context, state) {
                            return (state is WeatherLoadingAccessState)
                                ? _buildLoadingWeatherWidget(blur: 0)
                                : (state is WeatherSuccessAccessState)
                                    ? _buildWeatherWidget(
                                        consolidatedWeather: state
                                            .weatherDTO.consolidatedWeather[1],
                                        locationName: state.weatherDTO.title,
                                        sourceName:
                                            state.weatherDTO.sources[1].title,
                                        sunrise: state.weatherDTO.sunRise,
                                        sunset: state.weatherDTO.sunSet,
                                        blur: 0,
                                      )
                                    : Container();
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) {
      FocusScope.of(context).unfocus();
      _searchController.clear();
      _isClearSearch = false;
      _weatherSearchBloc.add(WeatherClearSearchEvent());
    });
  }

  Widget _buildWeatherWidget({
    required String locationName,
    required ConsolidatedWeather consolidatedWeather,
    required String sunrise,
    required String sunset,
    required String sourceName,
    required double blur,
  }) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(0),
      children: [
        _buildBoxWidget(
          width: MediaQuery.of(context).size.width,
          height: null,
          padding: 20,
          marginTop: 20,
          blur: blur,
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vị trí hiện tại',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 10)),
                Row(
                  children: [
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(
                            text: '$locationName\n',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text:
                                '${WeatherUtil.instance.getWeatherDescription(consolidatedWeather.weatherStateAbbr)}',
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${consolidatedWeather.theTemp.toInt()}\u2103',
                      style: TextStyle(
                        fontSize: 35,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBoxWidget(
              width: (MediaQuery.of(context).size.width / 2) - 30,
              height: (MediaQuery.of(context).size.width / 2) - 30,
              padding: 10,
              marginTop: 20,
              blur: blur,
              child: _buildSunStatusView(
                edge: _boxEdge,
                sunriseTime: sunrise,
                sunsetTime: sunset,
              ),
            ),
            _buildBoxWidget(
              width: (MediaQuery.of(context).size.width / 2) - 30,
              height: (MediaQuery.of(context).size.width / 2) - 30,
              padding: 10,
              marginTop: 20,
              blur: blur,
              child: _buildTemperatureWidget(
                edge: _boxEdge,
                minTemp: consolidatedWeather.minTemp,
                maxTemp: consolidatedWeather.maxTemp,
                currentTemp: consolidatedWeather.theTemp,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBoxWidget(
              width: (MediaQuery.of(context).size.width / 2) - 30,
              height: (MediaQuery.of(context).size.width / 2) - 30,
              padding: 10,
              marginTop: 20,
              blur: blur,
              child: _buildWindWidget(
                edge: _boxEdge,
                windSpeed: consolidatedWeather.windSpeed,
                windDirection: consolidatedWeather.windDirection,
                windCompass: consolidatedWeather.windDirectionCompass,
              ),
            ),
            _buildBoxWidget(
              width: (MediaQuery.of(context).size.width / 2) - 30,
              height: (MediaQuery.of(context).size.width / 2) - 30,
              padding: 10,
              marginTop: 20,
              blur: blur,
              child: _buildAirPressureWidget(
                edge: _boxEdge,
                airPressure: consolidatedWeather.airPressure,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBoxWidget(
              width: (MediaQuery.of(context).size.width / 2) - 30,
              height: (MediaQuery.of(context).size.width / 2) - 30,
              padding: 10,
              marginTop: 20,
              blur: blur,
              child: _buildvisibilityWidget(
                edge: _boxEdge,
                visibility: consolidatedWeather.visibility,
              ),
            ),
            _buildBoxWidget(
              width: (MediaQuery.of(context).size.width / 2) - 30,
              height: (MediaQuery.of(context).size.width / 2) - 30,
              padding: 10,
              marginTop: 20,
              blur: blur,
              child: _buildHumidityWidget(
                edge: _boxEdge,
                humidity: consolidatedWeather.humidity,
              ),
            ),
          ],
        ),
        _buildFooterWidget(
          predictability: consolidatedWeather.predictability,
          sourceName: sourceName,
        ),
      ],
    );
  }

  Widget _buildLoadingWeatherWidget({required double blur}) {
    return _buildBoxWidget(
      width: MediaQuery.of(context).size.width,
      height: null,
      padding: 20,
      marginTop: 20,
      blur: blur,
      child: Container(
        child: Text(
          'Đang tải dữ liệu...',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPositionWidget() {
    return Container();
  }

  Widget _buildSunStatusView({
    required double edge,
    required String sunriseTime,
    required String sunsetTime,
  }) {
    double thickness = 0.25;
    // - 20 means:  Label bottom with 20 unit height
    double widgetEdge = edge - 20;
    double sunrisePosition =
        (TimeUtil.instance.formatTimeToPercent(sunriseTime) * widgetEdge / 100);
    double sunsetPosition =
        (TimeUtil.instance.formatTimeToPercent(sunsetTime) * widgetEdge / 100);
    double currentPosition =
        (TimeUtil.instance.formatTimeToPercent(DateTime.now().toString()) *
            widgetEdge /
            100);
    return Container(
      width: edge,
      height: widgetEdge,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          //
          //sun rise
          Positioned(
            top: sunrisePosition - 18,
            child: Container(
              width: edge,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      TimeUtil.instance.formatHour(sunriseTime),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Mặt trời mọc',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: sunrisePosition,
            child: Container(
              width: edge,
              height: thickness,
              color: Theme.of(context).hintColor,
            ),
          ),
          //
          //sunset
          Positioned(
            top: sunsetPosition - 18,
            child: Container(
              width: edge,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      TimeUtil.instance.formatHour(sunsetTime),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Mặt trời lặn',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: sunsetPosition,
            child: Container(
              width: edge,
              // margin: EdgeInsets.only(bottom: (25 * edge / 100)),
              height: thickness,
              color: Theme.of(context).hintColor,
            ),
          ),
          //
          //current time
          Positioned(
            top: currentPosition,
            child: Container(
              width: edge,
              child: CustomPaint(
                painter: DottedLinePainter(
                  context: context,
                  color: WeatherUtil.instance.getTimeSunColor(),
                  thickness: 0.5,
                ),
              ),
            ),
          ),
          Positioned(
            top: currentPosition - 11,
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: WeatherUtil.instance.getTimeSunColor(),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: WeatherUtil.instance.getTimeSunColor(),
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Text(
                TimeUtil.instance.formatHourView(DateTime.now()),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ),

          //
          //label
          Positioned(
              bottom: 0,
              child: Container(
                width: edge,
                alignment: Alignment.center,
                child: Text(
                  'Thời gian',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildTemperatureWidget({
    required double edge,
    required double minTemp,
    required double maxTemp,
    required double currentTemp,
  }) {
    //size of current tempurature circle
    final double dotSize = 25;
    maxTemp = maxTemp.ceilToDouble();
    minTemp = minTemp.floorToDouble();
    //check current Temp whether it's out of scope
    if (currentTemp < minTemp) {
      currentTemp = minTemp;
    } else if (currentTemp > maxTemp) {
      currentTemp = maxTemp;
    }
    //left padding of chart
    final double padding = 20;
    //height of container
    double widgetEdge = edge - padding;
    //
    //chart start from top, so
    //max temp position = 0
    //min temp position = height
    //
    //unit means: max - min
    double unit = maxTemp - minTemp;

    //pixel per unit
    double pixelPerUnit = widgetEdge / unit;

    //current temp position, start from top
    double currentTempUnit = maxTemp - currentTemp;
    double currentTempPosition = currentTempUnit * pixelPerUnit;

    return Container(
      width: edge,
      height: widgetEdge,
      margin: EdgeInsets.only(right: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          //max temp line
          Positioned(
            left: padding,
            top: 0,
            child: Container(
              width: widgetEdge,
              height: widgetEdge,
              decoration: BoxDecoration(
                gradient:
                    WeatherUtil.instance.getGradientWeather(maxTemp, minTemp),
              ),
            ),
          ),
          //min - max temp lines
          Positioned(
            left: padding,
            top: widgetEdge,
            child: Container(
              width: widgetEdge,
              height: 0.5,
              color: DefaultTheme.GREY_LIGHT,
            ),
          ),
          Positioned(
            left: padding,
            top: 0,
            child: Container(
              width: widgetEdge,
              height: 0.5,
              color: DefaultTheme.GREY_LIGHT,
            ),
          ),
          //
          //current temp dot
          Positioned(
            left: edge / 2 - padding / 2,
            top: currentTempPosition - (dotSize / 2),
            child: Container(
              width: dotSize,
              height: dotSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(dotSize),
                color: Theme.of(context).cardColor.withOpacity(0.6),
                border: Border.all(
                  color: WeatherUtil.instance.getTempuratureColor(currentTemp),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: DefaultTheme.NEON.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 25,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Text(
                currentTemp.toInt().toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
            ),
          ),
          //descriptions of thermometer
          Positioned(
            left: padding - 20,
            top: widgetEdge - 12,
            child: Container(
              width: 20,
              alignment: Alignment.topRight,
              child: Text(
                minTemp.toInt().toString(),
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Positioned(
            left: padding - 20,
            top: 0,
            child: Container(
              width: 20,
              alignment: Alignment.topRight,
              child: Text(
                maxTemp.toInt().toString(),
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ),

          //label
          Positioned(
            bottom: 0,
            child: Container(
              width: edge,
              alignment: Alignment.center,
              child: Text(
                'Nhiệt độ (\u2103)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWindWidget({
    required double edge,
    required double windSpeed,
    required double windDirection,
    required String windCompass,
  }) {
    final double compassLabelPadding = 8;
    final double padding = 20;
    final double widgetEdge = edge - (padding * 2);
    return Container(
      width: edge,
      height: widgetEdge,
      // margin: EdgeInsets.only(right: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          //compass
          Positioned(
            left: padding,
            top: padding / 2,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final Tween<double> _rotationTween =
                    Tween(begin: 0, end: _consolidatedWeather.windDirection);
                _animation = _rotationTween.animate(_animationController)
                  ..addStatusListener((status) {
                    if (status == AnimationStatus.completed) {
                      _animationController.stop();
                    } else if (status == AnimationStatus.dismissed) {
                      _animationController.forward();
                    }
                  });
                _animationController.forward();
                return CustomPaint(
                  //outsie circle
                  painter: CirclePainter(
                    context: context,
                    diameter: widgetEdge,
                  ),
                  //direction painter
                  foregroundPainter: DirectionPainter(
                    context: context,
                    diameter: widgetEdge,
                    direction: 360 - _animation.value,
                  ),
                );
              },
            ),
          ),

          //compass label
          Positioned(
            left: padding / 2 - (compassLabelPadding / 2),
            top: -compassLabelPadding / 2,
            child: Container(
              width: widgetEdge + padding + compassLabelPadding,
              height: widgetEdge + padding + compassLabelPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'B',
                    textAlign: TextAlign.center,
                    style: _labelCompassStyle(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'T',
                        textAlign: TextAlign.center,
                        style: _labelCompassStyle(),
                      ),
                      Text(
                        'Đ',
                        textAlign: TextAlign.center,
                        style: _labelCompassStyle(),
                      ),
                    ],
                  ),
                  Text(
                    'N',
                    textAlign: TextAlign.center,
                    style: _labelCompassStyle(),
                  ),
                ],
              ),
            ),
          ),

          //content
          Positioned(
            top: widgetEdge / 4 + padding / 2 - 5,
            left: widgetEdge / 4 + padding - 2.5,
            child: Container(
              width: widgetEdge / 2 + 5,
              height: widgetEdge / 2 + 5,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).hintColor,
                      ),
                      children: [
                        TextSpan(
                          text: '${windSpeed.toInt()}',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: ' km/h',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${_consolidatedWeather.windDirection.toInt()}\u00B0 ${WeatherUtil.instance.formatWindDirection(windCompass)}',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(height),
              //   color: Theme.of(context).cardColor.withOpacity(0.5),
              // ),
            ),
          ),
          //label
          Positioned(
            bottom: 0,
            child: Container(
              width: edge,
              alignment: Alignment.center,
              child: Text(
                'Gió',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAirPressureWidget({
    required double edge,
    required double airPressure,
  }) {
    final double padding = 10;
    final double widgetEdge = edge - (padding * 2);
    final double min = 870;
    final double max = 1080;
    if (airPressure < min) {
      airPressure = min;
    }
    if (airPressure > max) {
      airPressure = max;
    }
    return Container(
      width: edge,
      height: widgetEdge,
      // margin: EdgeInsets.only(right: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          //chart
          Positioned(
            left: padding,
            child: Container(
              width: widgetEdge,
              height: widgetEdge,
              //    color: Colors.red,
              child: CustomPaint(
                painter: RulerPainter(
                  context: context,
                  width: widgetEdge,
                  min: min,
                  max: max,
                  value: airPressure,
                ),
              ),
            ),
          ),

          //label
          Positioned(
            bottom: 0,
            child: Container(
              width: edge,
              alignment: Alignment.center,
              child: Text(
                'Áp suất không khí',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildvisibilityWidget({
    required double edge,
    required double visibility,
  }) {
    final double padding = 10;
    final double widgetEdge = edge - (padding * 2);
    return Container(
      width: edge,
      height: widgetEdge,
      // margin: EdgeInsets.only(right: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          //visibility view
          Positioned(
            left: padding,
            child: Container(
              width: widgetEdge,
              height: widgetEdge,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widgetEdge),
                boxShadow: [
                  BoxShadow(
                    color: WeatherUtil.instance
                        .getVisibilityColor(visibility)
                        .withOpacity(0.6),
                    blurRadius: 50,
                    spreadRadius: -10,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).hintColor,
                  ),
                  children: [
                    TextSpan(
                      text: '${visibility.toInt()}',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    TextSpan(
                      text: ' km',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //label
          Positioned(
            bottom: 0,
            child: Container(
              width: edge,
              alignment: Alignment.center,
              child: Text(
                'Tầm nhìn',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHumidityWidget({
    required double edge,
    required int humidity,
  }) {
    final double padding = 10;
    final double widgetEdge = edge - (padding * 2);
    final double humiditySize = humidity * 100 / widgetEdge;
    return Container(
      width: edge,
      height: widgetEdge,
      // margin: EdgeInsets.only(right: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          //humidity view
          Positioned(
            left: padding,
            bottom: padding * 2,
            child: Container(
              width: widgetEdge,
              height: humiditySize,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    DefaultTheme.WHITE..withOpacity(0.7),
                    DefaultTheme.WHITE.withOpacity(0.3),
                    DefaultTheme.WHITE.withOpacity(0.2),
                    DefaultTheme.WHITE.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          //humidity value
          Positioned(
            left: padding,
            bottom: humiditySize + 20,
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 15,
                ),
                children: [
                  TextSpan(
                    text: humidity.toString(),
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  TextSpan(
                    text: '%',
                  ),
                ],
              ),
            ),
          ),
          //label
          Positioned(
            bottom: 0,
            child: Container(
              width: edge,
              alignment: Alignment.center,
              child: Text(
                'Độ ẩm',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterWidget({
    required int predictability,
    required String sourceName,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 20, bottom: 50, left: 5),
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).hintColor,
          ),
          children: [
            TextSpan(
              text: 'Khả năng dự đoán là $predictability\n',
            ),
            TextSpan(
              text: 'Theo $sourceName',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoxWidget({
    required double width,
    required double? height,
    required double padding,
    required double? marginTop,
    required double blur,
    required Widget child,
  }) {
    return Container(
      margin: EdgeInsets.only(top: marginTop!),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blur,
            sigmaY: blur,
          ),
          child: Container(
            width: width,
            height: height,
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: DefaultTheme.WHITE.withOpacity(0.2),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  TextStyle _labelCompassStyle() {
    return TextStyle(
      color: Theme.of(context).hintColor,
      fontSize: 10,
    );
  }
}
