import 'package:cloud_firestore/cloud_firestore.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/order.dart';
import '../repository/order_repository.dart';

class OrderController extends ControllerMVC {
  List<Order> orders = <Order>[];
  GlobalKey<ScaffoldState>? scaffoldKey;
  Stream<QuerySnapshot>? OrderNoti;
  OverlayEntry? loader;
  OrderController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
  listenForOrderNotification() async {
        getOrderNotification().then((snapshots) {

          setState(() {
            OrderNoti = snapshots;
          });
        });


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
  void cancelOrderByDriver(Order order) async {
    loader = Helper.overlayLoader(state!.context);
    Overlay.of(state!.context)!.insert(loader!);
    cancelOrder(order.id).then((v) {
      setState(() {
        order.active = false;
      });
      if(v) {
        Helper.hideLoader(loader!);
        ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
          content: Text("لقد قمت بإلغاء توصيل الطلبية"),
        ));
      }else{
        loader!.remove();
        ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
        content: Text("للاسف لم يتم الغاء توصيل الطلبية"),
      ));}
    });
  }
  void listenForOrders({String? message}) async {
    final Stream<Order> stream = await getOrders();
    stream.listen((Order _order) {
      setState(() {
        orders.add(_order);
      });
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

  void listenForOrdersHistory({String? message}) async {
    final Stream<Order> stream = await getOrdersHistory();
    stream.listen((Order _order) {
      setState(() {
        orders.add(_order);
      });
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

  Future<void> refreshOrdersHistory() async {
    orders.clear();
    listenForOrdersHistory(message: S.of(state!.context)!.order_refreshed_successfuly);
  }

  Future<void> refreshOrders() async {
    orders.clear();
    listenForOrders(message: S.of(state!.context)!.order_refreshed_successfuly);
  }
}
