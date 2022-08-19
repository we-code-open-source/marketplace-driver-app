import 'dart:async';
import 'dart:io';

import 'package:overlay_support/overlay_support.dart';
import '../elements/notification_icon.dart';
import '../models/route_argument.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../helpers/custom_trace.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class SplashScreenController extends ControllerMVC with ChangeNotifier {
  ValueNotifier<Map<String, double>> progress = new ValueNotifier(new Map());
  GlobalKey<ScaffoldState>? scaffoldKey;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  SplashScreenController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    progress.value = {"Setting": 0, "User": 0};
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
    registerNotification();
    settingRepo.setting.addListener(() {
      if (settingRepo.setting.value.appName != null &&
          settingRepo.setting.value.appName != '' &&
          settingRepo.setting.value.mainColor != null) {
        progress.value["Setting"] = 41;
        progress.notifyListeners();
      }
    });
    userRepo.currentUser.addListener(() {
      if (userRepo.currentUser.value.auth != null) {
        progress.value["User"] = 59;
        progress.notifyListeners();
      }
    });
    Timer(Duration(seconds: 20), () {
      ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
        content: Text(S.of(state!.context)!.verify_your_internet_connection),
      ));
    });
  }

  void registerNotification() {
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('onMessage : ${message.notification!.title!}');
        showSimpleNotification(
          Text(message.notification!.title!),
          subtitle: Text(
            message.notification!.body!,
          ),
          leading: NotificationIcon(),
          background: Theme.of(state!.context).accentColor,
          duration: Duration(seconds: 4),
        );
      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if(message.data['id']!=null)
        settingRepo.navigatorKey.currentState!.pushReplacementNamed(
            '/OrderDetailsNot',
            arguments: RouteArgument(id: message.data['id'].toString()));
      });

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(
       message) async {
    print('onBackgroundMessage : ${message.notification!.title!}');
    showSimpleNotification(
      Text(message.notification!.title!),
      subtitle: Text(
        message.notification!.body!,
      ),
      leading: NotificationIcon(),
      background: Theme.of(state!.context).accentColor,
      duration: Duration(seconds: 4),
    );
  }
}
