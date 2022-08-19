import 'package:deliveryboy/src/models/driver.dart';

import '../helpers/custom_trace.dart';
import '../models/media.dart';

class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? newPassword;
  String? apiToken;
  String? type;
  String? deviceToken;
  String? phone;
  String? token;
  String? address;
  String? bio;
  Media? image;
  Driver? driver;
  bool? auth;
  User();

  User.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'] != null ? jsonMap['name'] : '';
      email = jsonMap['email'] != null ? jsonMap['email'] : '';
      apiToken = jsonMap['api_token'];
      deviceToken = jsonMap['device_token'];
      driver = jsonMap['driver'] != null ? new Driver.fromJson(jsonMap['driver']) : null;
      phone=jsonMap['phone_number'] != null ? jsonMap['phone_number'] : '';
      try {
        address = jsonMap['custom_fields']['address']['view'];
      } catch (e) {
        address = "";
      }
      try {
        bio = jsonMap['custom_fields']['bio']['view'];
      } catch (e) {
        bio = "";
      }
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? Media.fromJSON(jsonMap['media'][0]) : new Media();
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["password"] = password;
    map["api_token"] = apiToken;
    if (deviceToken != null) {
      map["device_token"] = deviceToken;
    }
    map["phone_number"] = phone;
    map["token"] = token;
    map["address"] = address;
    map["type"] = type;
    map["bio"] = bio;
    map["media"] = image?.toMap();
    return map;
  }
  Map toPasswordMap() {
    var map = new Map<String, dynamic>();

    map["password"] = password;
    map["new_password"] = newPassword;

    return map;
  }
  Map toRestrictMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["thumb"] = image?.thumb;
    return map;
  }

  @override
  String toString() {
    var map = this.toMap();
    map["auth"] = this.auth;
    return map.toString();
  }

  bool profileCompleted() {
    return address != null && address != '' && phone != null && phone != '';
  }
}
