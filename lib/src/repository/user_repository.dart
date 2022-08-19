import 'dart:convert';
import 'dart:io';

import '../helpers/base.dart';
import '../models/confirm_reset_code.dart';
import '../models/driver_type.dart';
import '../models/reset_password.dart';
import '../models/statistic.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/credit_card.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

ValueNotifier<User> currentUser = new ValueNotifier(User());
ValueNotifier<int> statusCode = new ValueNotifier(0);
ValueNotifier<bool> workingOnOrder = new ValueNotifier(false);
ValueNotifier<int> numOfReq = new ValueNotifier(0);

Future<User> login(User user) async {
  final String url = '${apiBaseUrl}login';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  print(response.body);
  if (response.statusCode == 200) {
    statusCode.value = 200;
    setCurrentUser(response.body);
    currentUser.value = User.fromJSON(json.decode(response.body)['data']);
  } else if (response.statusCode == 401) {
    print("statusCode 401");
    statusCode.value = 401;
  } else if (response.statusCode == 403) {
    print("statusCode 403");
    statusCode.value = 403;
  } else if (response.statusCode == 422) {
    print("statusCode 422");
    statusCode.value = 422;
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
  return currentUser.value;
}

Future<bool> checkPhoneRegister(String phone) async {
  numOfReq.value++;
  final String url =
      '${apiBaseUrl}register?phone_number=$phone';
  final client = new http.Client();
  final response = await client.get(
    Uri.parse(url),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json'
    },
  );
  print(response.body);
  print(response.statusCode);
  if (response.statusCode == 200) {
    statusCode.value = 200;
    return true;
  } else if (response.statusCode == 422) {
    statusCode.value = 422;
    return false;
  }if (response.statusCode == 400) {
    statusCode.value = 400;
    return false;
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}

Future<String> ConfirmRegister(ConfirmResetCode confirmResetCode) async {
  final String url =
      '${apiBaseUrl}confirm_register';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(confirmResetCode.toMap()),
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)['token'];
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}

Future<bool> register(User user, File image) async {
  final String url =
      '${apiBaseUrl}register';
  print(url);
  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-type": "multipart/form-data"
  };
  //create multipart request for POST or PATCH method
  var request = http.MultipartRequest("POST", Uri.parse(url));
  print("==========");
  print(user.toMap());
  print(user.id);
  print(user.password);
  print(image.path);
  print("==========");
  var pic = await http.MultipartFile.fromPath("image", image.path);
  //add multipart to request

  request.files.add(pic);
  //add text fields
  request.fields["name"] = user.name!;
  request.fields["email"] = user.email!;
  request.fields["password"] = user.password!;
  request.fields["phone_number"] = user.phone!;
  request.fields["token"] = user.token!;
  request.fields["driver_type_id"] = user.id!;
  //create multipart using filepath, string or bytes

  request.headers.addAll(headers);
  // request.fields.addAll(user.toMap());

  //request.fields.addAll(user.toMap());
  print("request: " + request.fields.toString());
  print("request: " + request.files.toString());
  var response = await request.send();
  print("response: " + response.toString());
  if (response.statusCode == 200) statusCode.value = 200;

  //Get the response from the server
  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);

  print("++++++++++");
  print(response.statusCode);
  print(responseString);
  print("++++++++++");
  return true;
}

Future<bool> checkPhoneResetPassword(String phone) async {
  final String url =
      '${apiBaseUrl}reset_password?phone_number=$phone';
  final client = new http.Client();
  final response = await client.get(
    Uri.parse(url),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json'
    },
  );
  print(response.body);
  print(response.statusCode);
  if (response.statusCode == 200) {
    statusCode.value = 200;
    return true;
  } else if (response.statusCode == 422) {
    statusCode.value = 422;
    return false;
  }if (response.statusCode == 400) {
    statusCode.value = 400;
    return false;
  }else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}

Future<String> ConfirmResetVerificationCode(
    ConfirmResetCode confirmResetCode) async {
  final String url =
      '${apiBaseUrl}confirm_reset_code';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(confirmResetCode.toMap()),
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)['token'];
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}

Future<bool> resetPassword(ResetPassword resetPassword) async {
  final String url =
      '${apiBaseUrl}reset_password';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(resetPassword.toMap()),
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)['data'];
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}

Future<User?> getUserProfile() async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${apiBaseUrl}profile?$_apiToken';
  try {
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    if (response.statusCode == 200) {
      print('TOMap: ${json.decode(response.body)['data']}');
      return User.fromJSON(json.decode(response.body)['data']);
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      throw new Exception(response.body);
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url));
  }
}

Future<Statistics?> getStatistics() async {
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${apiBaseUrl}statistics?$_apiToken';
  try {
    final client = new http.Client();
    final response = await client.get(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    print(url);
    if (response.statusCode == 200) {
      print('TOMap: ${json.decode(response.body)['data']}');
      return Statistics.fromJson(json.decode(response.body)['data']);
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      throw new Exception(response.body);
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url));
  }
}

Future<bool> imageUpload(File file) async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${apiBaseUrl}update-profile-image?$_apiToken';
  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-type": "multipart/form-data"
  };
  //create multipart request for POST or PATCH method
  var request = http.MultipartRequest("POST", Uri.parse(url));
  var pic = await http.MultipartFile.fromPath("image", file.path);
  //add multipart to request
  request.files.add(pic);
  request.headers.addAll(headers);
  var response = await request.send();
  print("+++++++++++++++++++++");
  //Get the response from the server
  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);
  print(response.statusCode);
  print(responseString);
  print("+++++++++++++++++++++");
  if (response.statusCode == 200)
    return true;
  else
    return false;
}

Future<void> logout(deviceToken) async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${apiBaseUrl1}logout?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
      Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json'},
    body: json.encode({
      'device_token': deviceToken,
    })
  );
  print(response.body);
  print(response.statusCode);
  if (response.statusCode == 200) {
    currentUser.value = new User();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }

}

void setCurrentUser(jsonString) async {
  try {
    if (json.decode(jsonString)['data'] != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'current_user', json.encode(json.decode(jsonString)['data']));
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: jsonString).toString());
    throw new Exception(e);
  }
}

Future<void> setCreditCard(CreditCard creditCard) async {
  if (creditCard != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('credit_card', json.encode(creditCard.toMap()));
  }
}

Future<User> getCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (currentUser.value.auth == null && prefs.containsKey('current_user')) {
    currentUser.value =
        User.fromJSON(json.decode(await prefs.getString('current_user')!));
    currentUser.value.auth = true;
  } else {
    currentUser.value.auth = false;
  }
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  currentUser.notifyListeners();
  return currentUser.value;
}

Future<void> updateDriverAvailable(driverState) async {
  final String _apiToken = 'api_token=${currentUser.value.apiToken}';
  final String url =
      '${baseURL}api/driver/update-status?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode({'available': driverState}),
  );
  print("res  " + response.body);
  //return response.body;
}

Future<CreditCard> getCreditCard() async {
  CreditCard _creditCard = new CreditCard();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('credit_card')) {
    _creditCard =
        CreditCard.fromJSON(json.decode(await prefs.getString('credit_card')!));
  }
  return _creditCard;
}

Future<User> update(User user) async {
  final String _apiToken = 'api_token=${currentUser.value.apiToken}';
  final String url =
      '${apiBaseUrl}users/${currentUser.value.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  setCurrentUser(response.body);
  currentUser.value = User.fromJSON(json.decode(response.body)['data']);
  return currentUser.value;
}

Future<Stream<Address>> getAddresses() async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${apiBaseUrl}delivery_addresses?$_apiToken&search=user_id:${_user.id}&searchFields=user_id:=&orderBy=is_default&sortedBy=desc';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Address.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url));
    return new Stream.value(new Address.fromJSON({}));
  }
}

Future<Address> addAddress(Address address) async {
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  address.userId = _user.id;
  final String url =
      '${apiBaseUrl}delivery_addresses?$_apiToken';
  final client = new http.Client();
  try {
    final response = await client.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(address.toMap()),
    );
    return Address.fromJSON(json.decode(response.body)['data']);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url));
    return new Address.fromJSON({});
  }
}

Future<Address> updateAddress(Address address) async {
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  address.userId = _user.id;
  final String url =
      '${apiBaseUrl}delivery_addresses/${address.id}?$_apiToken';
  final client = new http.Client();
  try {
    final response = await client.put(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(address.toMap()),
    );
    return Address.fromJSON(json.decode(response.body)['data']);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url));
    return new Address.fromJSON({});
  }
}

Future<Address> removeDeliveryAddress(Address address) async {
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${apiBaseUrl}delivery_addresses/${address.id}?$_apiToken';
  final client = new http.Client();
  try {
    final response = await client.delete(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    return Address.fromJSON(json.decode(response.body)['data']);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url));
    return new Address.fromJSON({});
  }
}

Future<Stream<DriverType>> getTypes() async {
  Uri uri = Helper.getUri('api/driver/driverTypes');
  print(uri);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return DriverType.fromJson(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new DriverType.fromJson({}));
  }
}

Future<bool> updatePassword(User user) async {
  print(user.toPasswordMap());
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${apiBaseUrl1}users/change_password?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toPasswordMap()),
  );
  if (response.statusCode == 200)
    return true;
  else
    return false;
}
