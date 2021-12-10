import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/routes/routes.dart';
import 'package:health_project/features/calendar/blocs/calendar_bloc.dart';
import 'package:health_project/features/calendar/repositories/calendar_repository.dart';
import 'package:health_project/features/health/blocs/health_bloc.dart';
import 'package:health_project/features/health/repositories/health_repository.dart';
import 'package:health_project/features/health/views/activity_view.dart';
import 'package:health_project/features/health/views/blood_pressure_view.dart';
import 'package:health_project/features/health/views/heart_rate_view.dart';
import 'package:health_project/features/home/home_view.dart';
import 'package:health_project/features/home/theme_setting_view.dart';
import 'package:health_project/features/login/blocs/login_bloc.dart';
import 'package:health_project/features/login/repositories/account_repository.dart';
import 'package:health_project/features/login/views/login_view.dart';
import 'package:health_project/features/news/blocs/cat_news_bloc.dart';
import 'package:health_project/features/news/blocs/news_bloc.dart';
import 'package:health_project/features/news/blocs/weather_bloc.dart';
import 'package:health_project/features/news/repositories/news_repository.dart';
import 'package:health_project/features/news/repositories/weather_repository.dart';
import 'package:health_project/features/notification/blocs/notification_bloc.dart';
import 'package:health_project/features/notification/repositories/notification_repository.dart';
import 'package:health_project/features/personal/blocs/personal_bloc.dart';
import 'package:health_project/features/personal/repositories/personal_repository.dart';
import 'package:health_project/features/personal/views/information_view.dart';
import 'package:health_project/features/peripheral/blocs/peripheral_bloc.dart';
import 'package:health_project/features/peripheral/repositories/peripheral_repository.dart';
import 'package:health_project/features/peripheral/views/connect_peripheral_view.dart';
import 'package:health_project/features/peripheral/views/intro_connect_view.dart';
import 'package:health_project/features/peripheral/views/peripheral_info_view.dart';
import 'package:health_project/services/authentication_helper.dart';
import 'package:health_project/services/calendar_provider.dart';
import 'package:health_project/services/gender_select_provider.dart';
import 'package:health_project/services/heart_rate_helper.dart';
import 'package:health_project/services/news_page_provider.dart';
import 'package:health_project/services/notification_count_provider.dart';
import 'package:health_project/services/page_select_provider.dart';
import 'package:health_project/services/peripheral_connecting_provider.dart';
import 'package:health_project/services/peripheral_helper.dart';
import 'package:health_project/services/phone_confirm_provider.dart';
import 'package:health_project/services/scroll_provider.dart';
import 'package:health_project/services/sqflite_helper.dart';
import 'package:health_project/services/tab_provider.dart';
import 'package:health_project/services/theme_helper.dart';
import 'package:health_project/services/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';

//Repositories
final AccountRepository accountRepository =
    AccountRepository(httpClient: http.Client());
final WeatherRepository _weatherRepository =
    WeatherRepository(httpClient: http.Client());
final NewsRepository newsRepository = NewsRepository(httpClient: http.Client());
final CalendarRepository _calendarRepository =
    CalendarRepository(httpClient: http.Client());
final NotificationRepository notificationRepository =
    NotificationRepository(httpClient: http.Client());
final PersonalRepository personalRepository =
    PersonalRepository(httpClient: http.Client());
final PeripheralRepository peripheralRepository = PeripheralRepository();
final HealthRepository healthRepository =
    HealthRepository(httpClient: http.Client());

//widget
late Widget _startScren;

//Share Preferences
late SharedPreferences sharedPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  await Geolocator.requestPermission();
  _initialServiceHelper();
  _getAuthorizeUser();
  runApp(HealthProject());
}

void _getAuthorizeUser() {
  final bool isAuthenticated = AuthenticateHelper.instance.isAuthenticated();
  if (isAuthenticated) {
    _startScren = HomeView();
  } else {
    _startScren = LoginView();
  }
}

void _initialServiceHelper() {
  if (!sharedPrefs.containsKey('AUTHENTICATION') ||
      sharedPrefs.getBool('AUTHENTICATION') == null) {
    AuthenticateHelper.instance.innitalAuthentication();
  }
  if (!sharedPrefs.containsKey('THEME_SYSTEM') ||
      sharedPrefs.getString('THEME_SYSTEM') == null) {
    ThemeHelper.instance.initialTheme();
  }
  if (!sharedPrefs.containsKey('PERIPHERAL_CONNECT') ||
      sharedPrefs.getBool('PERIPHERAL_CONNECT') == null) {
    PeripheralHelper.instance.initialPeripheralHelper();
  }
  if (!sharedPrefs.containsKey('LAST_HEART_RATE') ||
      sharedPrefs.getInt('LAST_HEART_RATE') == null) {
    HeartRateHelper.instance.initialHeartRateHelper();
  }
}

class HealthProject extends StatelessWidget {
  const HealthProject();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WeatherBloc>(
          create: (BuildContext context) =>
              WeatherBloc(weatherRepository: _weatherRepository),
        ),
        BlocProvider<WeatherSearchBloc>(
          create: (BuildContext context) =>
              WeatherSearchBloc(weatherRepository: _weatherRepository),
        ),
        BlocProvider<CategoryNewsBloc>(
          create: (BuildContext context) =>
              CategoryNewsBloc(repository: newsRepository),
        ),
        BlocProvider<ThumbnailNewsBloc>(
          create: (BuildContext context) =>
              ThumbnailNewsBloc(repository: newsRepository),
        ),
        BlocProvider<LastestNewsBloc>(
          create: (BuildContext context) =>
              LastestNewsBloc(repository: newsRepository),
        ),
        BlocProvider<RelatedNewsBloc>(
          create: (BuildContext context) =>
              RelatedNewsBloc(repository: newsRepository),
        ),
        BlocProvider<NewsBloc>(
          create: (BuildContext context) =>
              NewsBloc(repository: newsRepository),
        ),
        BlocProvider<CalendarBloc>(
          create: (BuildContext context) => CalendarBloc(
              calendarRepository: _calendarRepository,
              sqfLiteHelper: SQFLiteHelper.instance),
        ),
        BlocProvider<NotificationBloc>(
          create: (BuildContext context) =>
              NotificationBloc(notificationRepository: notificationRepository),
        ),
        BlocProvider<LoginBloc>(
          create: (BuildContext context) =>
              LoginBloc(accountRepository: accountRepository),
        ),
        BlocProvider<PersonalBloc>(
          create: (BuildContext context) =>
              PersonalBloc(personalRepository: personalRepository),
        ),
        BlocProvider<PeripheralBLoc>(
          create: (BuildContext context) =>
              PeripheralBLoc(peripheralRepository: peripheralRepository),
        ),
        BlocProvider<ActivityBloc>(
          create: (BuildContext context) => ActivityBloc(
            healthRepository: healthRepository,
            peripheralRepository: peripheralRepository,
            sqfLiteHelper: SQFLiteHelper.instance,
          ),
        ),
        BlocProvider<HeartRateBloc>(
          create: (BuildContext context) => HeartRateBloc(
            healthRepository: healthRepository,
            peripheralRepository: peripheralRepository,
            sqfLiteHelper: SQFLiteHelper.instance,
          ),
        ),
        BlocProvider<BMIBloc>(
          create: (BuildContext context) =>
              BMIBloc(healthRepository: healthRepository),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => PageSelectProvider()),
            ChangeNotifierProvider(create: (context) => ScrollProvider()),
            ChangeNotifierProvider(create: (context) => ThemeProvider()),
            ChangeNotifierProvider(create: (context) => TabProvider()),
            ChangeNotifierProvider(create: (context) => CalendarProvider()),
            ChangeNotifierProvider(create: (context) => CalendarDateProvider()),
            ChangeNotifierProvider(
                create: (context) => NotificationCountProvider()),
            ChangeNotifierProvider(create: (context) => NewsPageProvider()),
            ChangeNotifierProvider(create: (context) => GenderSelectProvider()),
            ChangeNotifierProvider(create: (context) => PhoneConfirmProvider()),
            ChangeNotifierProvider(
                create: (context) => PeripheralConnectingProvider()),
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, themeSelect, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                themeMode:
                    (themeSelect.themeSystem == DefaultTheme.THEME_SYSTEM)
                        ? ThemeMode.system
                        : (themeSelect.themeSystem == DefaultTheme.THEME_LIGHT)
                            ? ThemeMode.light
                            : ThemeMode.dark,
                darkTheme: DefaultThemeData(context: context).darkTheme,
                theme: DefaultThemeData(context: context).lightTheme,
                initialRoute: Routes.INITIAL_ROUTE,
                routes: {
                  //add routes that you wanna push named
                  Routes.HOME: (context) => HomeView(),
                  Routes.SETTING_THEME: (context) => ThemeSettingView(),
                  Routes.INFOR_VIEW: (context) => InformationView(),
                  Routes.INTRO_CONNECT_VIEW: (context) => IntroConnectView(),
                  Routes.CONNECT_PERIPHERAL_VIEW: (context) =>
                      ConnectPeripheralView(),
                  Routes.PERIPHERAL_INFOR_VIEW: (context) =>
                      PeripheralInfoView(),
                  Routes.ACTIVITY_VIEW: (context) => ActivityView(),
                  Routes.HEART_RATE_VIEW: (context) => HeartRateView(),
                  Routes.BLOOD_PRESSURE_VIEW: (context) => BloodPressureView(),
                },
                localizationsDelegates: [
                  // ... app-specific localization delegate[s] here
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: [
                  const Locale('en'), // English
                  const Locale('vi'), // Vietnamese
                ],
                home: _startScren,
              );
            },
          ),
        ),
      ),
    );
  }
}
