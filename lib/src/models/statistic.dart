import '../helpers/custom_trace.dart';

class Statistics {
  Settlements? settlements;
  OrdersForSettlement? availabelOrdersForSettlement;

  Statistics();

  Statistics.fromJson(Map<String, dynamic> json) {
    settlements = json['settlements'] != null
        ? new Settlements.fromJSON(json['settlements'])
        : null;
    availabelOrdersForSettlement =
    json['availabel_orders_for_settlement'] != null
        ? new OrdersForSettlement.fromJSON(
        json['availabel_orders_for_settlement'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.settlements != null) {
      data['settlements'] = this.settlements!.toMap();
    }
    if (this.availabelOrdersForSettlement != null) {
      data['availabel_orders_for_settlement'] =
          this.availabelOrdersForSettlement!.toMap();
    }
    return data;
  }
}

class Settlements {
  String? amount;
  String? delivery_fee;
  String? count;

  Settlements();

  Settlements.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      amount = jsonMap['amount'] != null ? jsonMap['amount'].toString() : '0.0';
      delivery_fee = jsonMap['delivery_fee'] != null ? jsonMap['delivery_fee'].toString() : '0.0';
      count = jsonMap['count'] != null ? jsonMap['count'].toString() : '0';
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['amount'] = this.amount;
    map['delivery_fee'] = this.delivery_fee;
    map['count'] = this.count;
    return map;
  }


}
class OrdersForSettlement {
  String? fee;
  String? delivery_fee;
  String? amountDeliveryCoupons;
  String? amountRestaurantCoupons;
  String? count;

  OrdersForSettlement();

  OrdersForSettlement.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      fee = jsonMap['fee'] != null ? jsonMap['fee'].toString() : '0.0';
      delivery_fee = jsonMap['delivery_fee'] != null ? jsonMap['delivery_fee'].toString() : '0.0';
      amountRestaurantCoupons = jsonMap['amount_restaurant_coupons'] != null ? jsonMap['amount_restaurant_coupons'].toString() : '0.0';
      amountDeliveryCoupons = jsonMap['amount_delivery_coupons'] != null ? jsonMap['amount_delivery_coupons'].toString() : '0.0';
      count = jsonMap['count'] != null ? jsonMap['count'].toString() : '0';
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['fee'] = this.fee;
    map['delivery_fee'] = this.delivery_fee;
    map['count'] = this.count;
    return map;
  }


}