import '../helpers/custom_trace.dart';

class OrderStatus {
  String? id;
  String? status;
  String? key;

  OrderStatus();

  OrderStatus.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      status = jsonMap['status'] != null ? jsonMap['status'] : '';
      key = jsonMap['key'] != null ? jsonMap['key'] : '';
    } catch (e) {
      id = '';
      status = '';
      key = '';
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }
}
