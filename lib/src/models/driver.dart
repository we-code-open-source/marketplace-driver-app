
import 'driver_type.dart';

class Driver {
  int? id;
  int? userId;
  int? deliveryFee;
  int? totalOrders;
  int? earning;
  bool? available;
  String? driverTypeId;
  DriverType? driverType;


  Driver();

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverTypeId = json['driver_type_id'].toString();
    userId = json['user_id'];
    deliveryFee = json['delivery_fee'];
    totalOrders = json['total_orders'];
    earning = json['earning'];
    available = json['available'];
    driverType = json['driverType'] != null ? new DriverType.fromJson(json['driverType']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['delivery_fee'] = this.deliveryFee;
    data['total_orders'] = this.totalOrders;
    data['earning'] = this.earning;
    data['available'] = this.available;
    data['driver_type_id'] = this.driverTypeId;
    return data;
  }
}
