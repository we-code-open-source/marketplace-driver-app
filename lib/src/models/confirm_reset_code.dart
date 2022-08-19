
import '../helpers/custom_trace.dart';

class ConfirmResetCode {
  String? phone_number;
  String? code;


  ConfirmResetCode();

  ConfirmResetCode.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      phone_number = jsonMap['phone_number'] != null ? jsonMap['phone_number'] : '';
      code = jsonMap['code'] != null ? jsonMap['code'] : '';
     } catch (e) {
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["phone_number"] = phone_number;
    map["code"] = code;
    return map;
  }

}
