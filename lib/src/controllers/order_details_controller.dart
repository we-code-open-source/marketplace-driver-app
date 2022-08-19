import '../helpers/helper.dart';
import '../models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/order.dart';
import '../repository/order_repository.dart';

class OrderDetailsController extends ControllerMVC {
  Order? order;
  GlobalKey<ScaffoldState>? scaffoldKey;
  OverlayEntry? loader;
String? orderStatus;
  OrderDetailsController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
  void acceptanceOrderByDriver(id) async {
    loader = Helper.overlayLoader(state!.context);
    Overlay.of(state!.context)!.insert(loader!);
    acceptanceOrder(id).then((v) {
      if(v) {
        Helper.hideLoader(loader!);
        Navigator.of(state!.context).pushNamed('/OrderDetails', arguments: RouteArgument(id: id.toString()));
        ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
          content: Text("لقد قمت باستلام الطلبية"),
        ));
      }else {
        loader!.remove();
        ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
          content: Text("للاسف لقد سابقك احد السائقين في قبول الطلبية"),
        ));}
    });
  }
  void listenForOrder({String? id, String? message}) async {
    final Stream<Order> stream = await getOrder(id);
    stream.listen((Order _order) {
      setState(() {
        order = _order;
        if(order!.orderStatus!.id == '40')
          orderStatus=S.of(state!.context)!.driver_arrived_restaurant;
        else if(order!.orderStatus!.id == '45')
          orderStatus=S.of(state!.context)!.driver_pick_up;
        else if(order!.orderStatus!.id == '50')
          orderStatus=S.of(state!.context)!.on_the_way;
        else if(order!.orderStatus!.id == '60')
          orderStatus=S.of(state!.context)!.driver_arrived;
        else if(order!.orderStatus!.id == '70')
          orderStatus=S.of(state!.context)!.delivered;
                   }
      );
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
        content: Text(S.of(state!.context)!.verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }
  void listenForOrderWorkOn({String? message}) async {
    final Stream<Order> stream = await getOrderWorkOn();
    stream.listen((Order _order) {
      setState(() {
        order = _order;
        if(order!.orderStatus!.id == '40')
          orderStatus=S.of(state!.context)!.driver_pick_up;
        else if(order!.orderStatus!.id == '50')
          orderStatus=S.of(state!.context)!.on_the_way;
        else if(order!.orderStatus!.id == '60')
          orderStatus=S.of(state!.context)!.driver_arrived;
        else if(order!.orderStatus!.id == '70')
          orderStatus=S.of(state!.context)!.delivered;
                   }
      );
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
        content: Text(S.of(state!.context)!.verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> refreshOrder() async {
    listenForOrder(id: order!.id, message: S.of(state!.context)!.order_refreshed_successfuly);
  }

  void doDeliveredOrder(Order _order) async {
    loader = Helper.overlayLoader(state!.context);
    Overlay.of(state!.context)!.insert(loader!);
    deliveredOrder(_order).then((value) {
      setState(() {
        this.order!.orderStatus!.id = _order.orderStatus!.id;
         _order.orderStatus!.id ==
            '50'
            ? orderStatus=S.of(state!.context)!.on_the_way
            : _order.orderStatus!.id ==
            '60'
            ? orderStatus=S.of(state!.context)!.driver_arrived
            : _order.orderStatus!.id ==
            '70'
            ? orderStatus=S.of(state!.context)!.delivered
            : orderStatus=S.of(state!.context)!.driver_pick_up;
      });
      if(value) {
        listenForOrder(id: _order.id);
        Helper.hideLoader(loader!);
        if(_order.orderStatus!.id=="80"){
        Navigator.of(state!.context).pushReplacementNamed(
            "/Pages", arguments: 3);
        ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
          content: Text('تم تسليم الطلب بنجاح إلى العميل'),
        ));
      }else  Navigator.of(state!.context).pop();
        }
    });
  }
}
