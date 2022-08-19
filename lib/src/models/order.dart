import 'package:deliveryboy/src/models/coupon.dart';

import '../helpers/custom_trace.dart';
import '../models/address.dart';
import '../models/food_order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/user.dart';

class Order {
  String? id;
  List<FoodOrder>? foodOrders;
  OrderStatus? orderStatus;
  UnregisteredCustomer? unregisteredCustomer;
  double? tax;
  double? deliveryFee;
  String? hint;
  DateTime? dateTime;
  int? deliveryCouponId;
  int? restaurantCouponId;
  double? deliveryCouponValue;
  double? restaurantCouponValue;
  User? user;
  Payment? payment;
  Address? deliveryAddress;
  DeliveryAddress? deliveryAdd;
  Coupon? restaurantCoupon;
  Coupon? deliveryCoupon;
  bool? active;
  Order();

  Order.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      tax = jsonMap['tax'] != null ? jsonMap['tax'].toDouble() : 0.0;
      deliveryFee = jsonMap['delivery_fee'] != null ? jsonMap['delivery_fee'].toDouble() : 0.0;
      deliveryCouponId = jsonMap['delivery_coupon_id']!= null ? jsonMap['delivery_coupon_id'] : null;
      restaurantCouponId = jsonMap['restaurant_coupon_id']!= null ? jsonMap['restaurant_coupon_id'] : null;
      deliveryCouponValue = jsonMap['delivery_coupon_value'] != null ? jsonMap['delivery_coupon_value'].toDouble() : 0.0;
      restaurantCouponValue = jsonMap['restaurant_coupon_value'] != null ? jsonMap['restaurant_coupon_value'].toDouble() : 0.0;
      hint = jsonMap['hint'].toString();
      active = jsonMap['active'] ?? false;
      restaurantCoupon = jsonMap['restaurant_coupon'] != null
          ? Coupon.fromJSON(jsonMap['restaurant_coupon'])
          : Coupon.fromJSON({});
      deliveryCoupon = jsonMap['delivery_coupon'] != null
          ? Coupon.fromJSON(jsonMap['delivery_coupon'])
          : Coupon.fromJSON({});
      unregisteredCustomer = jsonMap['unregistered_customer'] != null
          ? new UnregisteredCustomer.fromJson(jsonMap['unregistered_customer'])
          : null;
      deliveryAdd = jsonMap['delivery_address'] != null
          ? new DeliveryAddress.fromJson(jsonMap['delivery_address'])
          : null;
      orderStatus = jsonMap['order_status'] != null ? OrderStatus.fromJSON(jsonMap['order_status']) : new OrderStatus();
      dateTime = DateTime.parse(jsonMap['updated_at']);
      user = jsonMap['user'] != null ? User.fromJSON(jsonMap['user']) : new User();
      payment = jsonMap['payment'] != null ? Payment.fromJSON(jsonMap['payment']) : new Payment.init();
      deliveryAddress = jsonMap['delivery_address'] != null ? Address.fromJSON(jsonMap['delivery_address']) : new Address();
      foodOrders = jsonMap['food_orders'] != null ? List.from(jsonMap['food_orders']).map((element) => FoodOrder.fromJSON(element)).toList() : [];
    } catch (e) {
      id = '';
      tax = 0.0;
      deliveryFee = 0.0;
      hint = '';
      active = false;
      orderStatus = new OrderStatus();
      dateTime = DateTime(0);
      user = new User();
      deliveryAdd = DeliveryAddress.fromJson({});
      payment = new Payment.init();
      deliveryAddress = new Address();
      unregisteredCustomer = UnregisteredCustomer.fromJson({});
      foodOrders = [];
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["user_id"] = user?.id;
    map["order_status_id"] = orderStatus?.id;
    map["tax"] = tax;
    map["delivery_fee"] = deliveryFee;
    map['unregistered_customer'] = unregisteredCustomer?.toJson();
    map['delivery_address'] = deliveryAdd?.toJson();
    map["foods"] = foodOrders!.map((element) => element.toMap()).toList();
    map["payment"] = payment?.toMap();
    if (deliveryAddress?.id != null && deliveryAddress?.id != 'null') map["delivery_address_id"] = deliveryAddress!.id;
    return map;
  }

  Map deliveredMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["order_status_id"] = orderStatus!.id;
    return map;
  }

  bool canCancelOrder() {
    return this.orderStatus!.key == 'driver_assigned' ||
        this.orderStatus!.key == 'waiting_for_restaurant' ||
        this.orderStatus!.key == 'accepted_from_restaurant'; // 1 for order received status
  }
  bool canShowButton() {
    return this.orderStatus!.key == 'delivered' ||
        this.orderStatus!.key == 'waiting_for_restaurant'|| // 1 for order received status
        this.orderStatus!.key == 'canceled_restaurant_did_not_accept'|| // 1 for order received status
        this.orderStatus!.key == 'canceled_from_customer'|| // 1 for order received status
        this.orderStatus!.key == 'canceled_from_restaurant'|| // 1 for order received status
        this.orderStatus!.key == 'canceled_from_company'|| // 1 for order received status
        this.orderStatus!.key == 'canceled_from_driver'; // 1 for order received status
  }
}
class UnregisteredCustomer {
  String? id;
  String? phone;
  String? name;

  UnregisteredCustomer({this.id, this.phone, this.name});

  UnregisteredCustomer.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    phone = json['phone'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['name'] = this.name;
    return data;
  }
}
class DeliveryAddress {
  String? address;
  double? latitude;
  double? longitude;

  DeliveryAddress({this.address, this.latitude, this.longitude});

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}