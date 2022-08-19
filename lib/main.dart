import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'route_generator.dart';
import 'src/helpers/app_config.dart' as config;
import 'src/helpers/base.dart';
import 'src/helpers/custom_trace.dart';
import 'src/helpers/fallback-cupertino-localization-delegete.dart';
import 'src/models/setting.dart';
import 'src/repository/settings_repository.dart' as settingRepo;
import 'src/repository/user_repository.dart' as userRepo;
import 'package:timeago/timeago.dart' as timeago;
import 'package:overlay_support/overlay_support.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return Container();
  };
  print(CustomTrace(StackTrace.current, message: "base_url: ${baseURL}"));
  print(CustomTrace(StackTrace.current, message: "api_base_url: ${apiBaseUrl}"));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    settingRepo.initSettings();
    userRepo.getCurrentUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: settingRepo.setting,
        builder: (context, Setting _setting, _) {
          print(CustomTrace(StackTrace.current, message: _setting.toMap().toString()));
          FirebaseAnalytics analytics = FirebaseAnalytics.instance;
          return OverlaySupport.global(
              child:MaterialApp(
              navigatorObservers: [
                FirebaseAnalyticsObserver(analytics: analytics),
              ],
              navigatorKey: settingRepo.navigatorKey,
              title: 'Sabek: Partner',
              initialRoute: '/Splash',
              onGenerateRoute: RouteGenerator.generateRoute,
              debugShowCheckedModeBanner: false,
              locale: _setting.mobileLanguage!.value,
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                FallbackCupertinoLocalisationsDelegate()
              ],
              supportedLocales: S.delegate.supportedLocales,
              theme: _setting.brightness!.value == Brightness.light
                  ? ThemeData(
                      fontFamily: 'Tajawal',
                      primaryColor: Colors.white,
                      floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0, foregroundColor: Colors.white),
                      brightness: Brightness.light,
                      accentColor: config.Colors().mainColor(1),
                      dividerColor: config.Colors().accentColor(0.1),
                      focusColor: config.Colors().accentColor(1),
                      hintColor: config.Colors().secondColor(1),
                      textTheme: TextTheme(
                        headline5: TextStyle(fontSize: 20.0, color: config.Colors().mainColor(1), height: 1.35),
                        headline4: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: config.Colors().mainColor(1), height: 1.35),
                        headline3: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: config.Colors().mainColor(1), height: 1.35),
                        headline2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.Colors().mainColor(1), height: 1.35),
                        headline1: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w300, color: config.Colors().mainColor(1), height: 1.5),
                        subtitle1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: config.Colors().mainColor(1), height: 1.35),
                        headline6: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: config.Colors().mainColor(1), height: 1.35),
                        bodyText2: TextStyle(fontSize: 12.0, color: config.Colors().mainColor(1), height: 1.35),
                        bodyText1: TextStyle(fontSize: 14.0, color: config.Colors().mainColor(1), height: 1.35),
                        caption: TextStyle(fontSize: 12.0, color: config.Colors().mainColor(1), height: 1.35),
                      ),
                    )
                  : ThemeData(
                      fontFamily: 'Tajawal',
                      primaryColor: Color(0xFF252525),
                      brightness: Brightness.dark,
                      scaffoldBackgroundColor: Color(0xFF2C2C2C),
                      accentColor: config.Colors().mainDarkColor(1),
                      dividerColor: config.Colors().accentColor(0.1),
                      hintColor: config.Colors().secondDarkColor(1),
                      focusColor: config.Colors().accentDarkColor(1),
                      textTheme: TextTheme(
                        headline5: TextStyle(fontSize: 20.0, color: config.Colors().secondDarkColor(1), height: 1.35),
                        headline4: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: config.Colors().secondDarkColor(1), height: 1.35),
                        headline3: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: config.Colors().secondDarkColor(1), height: 1.35),
                        headline2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.Colors().mainDarkColor(1), height: 1.35),
                        headline1: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w300, color: config.Colors().secondDarkColor(1), height: 1.5),
                        subtitle1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: config.Colors().secondDarkColor(1), height: 1.35),
                        headline6: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: config.Colors().mainDarkColor(1), height: 1.35),
                        bodyText2: TextStyle(fontSize: 12.0, color: config.Colors().secondDarkColor(1), height: 1.35),
                        bodyText1: TextStyle(fontSize: 14.0, color: config.Colors().secondDarkColor(1), height: 1.35),
                        caption: TextStyle(fontSize: 12.0, color: config.Colors().secondDarkColor(0.6), height: 1.35),
                      ),
                    ))
          );});
  }
}
