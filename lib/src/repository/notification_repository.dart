import 'dart:convert';
import 'dart:io';
import '../helpers/base.dart';
import 'settings_repository.dart';
import 'package:http/http.dart' as http;
import '../helpers/helper.dart';
import '../models/notification.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

Future<Stream<Notification>> getNotifications() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(new Notification());
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${apiBaseUrl}notifications?${_apiToken}search=notifiable_id:${_user.id}&searchFields=notifiable_id:=&orderBy=created_at&sortedBy=desc&limit=10';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    return Notification.fromJSON(data);
  });
}

Future<Notification> markAsReadNotifications(Notification notification) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Notification();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${apiBaseUrl}notifications/${notification.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.put(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(notification.markReadMap()),
  );
  print("[${response.statusCode}] NotificationRepository markAsReadNotifications");
  return Notification.fromJSON(json.decode(response.body)['data']);
}

Future<Notification> removeNotification(Notification cart) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Notification();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${apiBaseUrl}notifications/${cart.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.delete(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  print("[${response.statusCode}] NotificationRepository removeCart");
  return Notification.fromJSON(json.decode(response.body)['data']);
}
Future<void> sendNotification(String body, String title, User user) async {
  final data = {
    "notification": {"body": "$body", "title": "$title"},
    "priority": "high",
    "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK", "id": "messages", "status": "done"},
    "to": "${user.deviceToken}"
  };
  final String url = 'https://fcm.googleapis.com/fcm/send';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: "key=${setting.value.fcmKey}",
    },
    body: json.encode(data),
  );
  if (response.statusCode != 200) {
    print('notification sending failed');
  }
}

