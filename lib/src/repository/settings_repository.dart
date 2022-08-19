import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

import '../helpers/base.dart';
import '../models/route_argument.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';

import '../helpers/custom_trace.dart';
import '../models/address.dart';
import '../models/setting.dart';
import '../models/user.dart';
import 'user_repository.dart';

ValueNotifier<Setting> setting = new ValueNotifier(new Setting());
ValueNotifier<Address> myAddress = new ValueNotifier(new Address());
final navigatorKey = GlobalKey<NavigatorState>();
//LocationData locationData;
const Privacy_Policy =
    'https://cp.sabek.app/privacy';
const APP_STORE_URL =
    'https://apps.apple.com/gb/app/sabek-partner/id1600324402?uo=2';
const PLAY_STORE_URL =
    'https://play.google.com/store/apps/details?id=ly.sabek.delivery';
Future<Setting> initSettings() async {
  Setting _setting;
  final String url = '${apiBaseUrl}settings';
  try {
    final response = await http.get(Uri.parse(url), headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    if (response.statusCode == 200 && response.headers.containsValue('application/json')) {
      if (json.decode(response.body)['data'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('settings', json.encode(json.decode(response.body)['data']));
        _setting = Setting.fromJSON(json.decode(response.body)['data']);
        if (prefs.containsKey('language')) {
          _setting.mobileLanguage!.value = Locale(prefs.getString('language')!, '');
        }
        _setting.brightness!.value = prefs.getBool('isDark') ?? false ? Brightness.dark : Brightness.light;
        setting.value = _setting;
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        setting.notifyListeners();
      }
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Setting.fromJSON({});
  }
  return setting.value;
}
listenCurrentLocation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if(!prefs.containsKey('permission'))setValue('acceptPermission');
  User user = new User();
  String? driverId;
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
  getUserProfile().then(
      (value) => location.onLocationChanged.listen((LocationData current) {
            if (currentUser.value.id != null) {
              try {
                FirebaseFirestore.instance
                    .collection("drivers")
                    .doc(currentUser.value.id)
                    .get()
                    .then((driver) {
                  driverId = driver['id'].toString();
                  workingOnOrder.value = driver['working_on_order'];
                  print(driverId);
                  if (driverId == null)
                    FirebaseFirestore.instance
                        .collection("drivers")
                        .doc(currentUser.value.id)
                        .set({
                      'id': currentUser.value.id,
                      'available': false,
                      'working_on_order': false,
                      'latitude': current.latitude,
                      'longitude': current.longitude,
                      'last_access': DateTime.now().millisecondsSinceEpoch
                    }).catchError((e) {
                      print(e);
                    });
                  else
                    FirebaseFirestore.instance
                        .collection("drivers")
                        .doc(currentUser.value.id)
                        .update({
                      'id': currentUser.value.id,
                      'latitude': current.latitude,
                      'longitude': current.longitude,
                      'last_access': DateTime.now().millisecondsSinceEpoch
                    }).catchError((e) {
                      print(e);
                    });
                });
              } catch (e) {
                print("Error in cloud firebase $e");
              }
            }
          }));
  location.enableBackgroundMode(enable: true);
}


Future<Address> changeCurrentLocation(Address _address) async {
  if (!_address.isUnknown()) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('delivery_address', json.encode(_address.toMap()));
  }
  return _address;
}

Future<Address> getCurrentLocation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
//  await prefs.clear();
  if (prefs.containsKey('my_address')) {
    myAddress.value = Address.fromJSON(json.decode(prefs.getString('my_address')!));
    return myAddress.value;
  } else {
    myAddress.value = Address.fromJSON({});
    return Address.fromJSON({});
  }
}
Future<void> setValue(value) async {
  if (value != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('permission', value);
  }
}
void setBrightness(Brightness brightness) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (brightness == Brightness.dark) {
    prefs.setBool("isDark", true);
    brightness = Brightness.dark;
  } else {
    prefs.setBool("isDark", false);
    brightness = Brightness.light;
  }
}

Future<void> setDefaultLanguage(String language) async {
  if (language != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }
}

Future<String> getDefaultLanguage(String defaultLanguage) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('language')) {
    defaultLanguage = await prefs.getString('language')!;
  }
  return defaultLanguage;
}

Future<void> saveMessageId(String messageId) async {
  if (messageId != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('google.message_id', messageId);
  }
}

Future<String> getMessageId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.getString('google.message_id')!;
}
versionCheck(context) async {
  final PackageInfo info = await PackageInfo.fromPlatform();
  double currentVersion = double.parse(info.version.trim().replaceAll(".", ""));
   Platform.isIOS
      ? {
    if (double.tryParse(setting.value.appVersionIOS!.replaceAll(".", ""))! >
        currentVersion)
      {
        if (setting.value.forceUpdateIOS!)
          Navigator.of(context).pushReplacementNamed('/ForceUpdate',
              arguments: RouteArgument(id: ''))
        else
          {
            Navigator.of(context).pushReplacementNamed('/ForceUpdate',
                arguments: RouteArgument(id: '0'))
          }
      }
    else
      Navigator.of(context).pushReplacementNamed('/Pages', arguments: 0)
  }
      : {
    if (double.tryParse(
        setting.value.appVersionAndroid!.replaceAll(".", ""))! >
        currentVersion)
      {
        if (setting.value.forceUpdateAndroid!)
          Navigator.of(context).pushReplacementNamed('/ForceUpdate',
              arguments: RouteArgument(id: ''))
        else
          {
            Navigator.of(context).pushReplacementNamed('/ForceUpdate',
                arguments: RouteArgument(id: '0'))
          }
      }
    else
      Navigator.of(context).pushReplacementNamed('/Pages', arguments: 0)
  };
}
launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
