import '../helpers/custom_trace.dart';
class ResetPassword {
  String? token;
  String? password;
  ResetPassword();

  ResetPassword.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      token = jsonMap['token'] != null ? jsonMap['token'] : '';
      password = jsonMap['password'] != null ? jsonMap['password'] : '';
     } catch (e) {
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["token"] = token;
    map["password"] = password;
    return map;
  }

}
