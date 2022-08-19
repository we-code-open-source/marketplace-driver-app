import 'package:cloud_firestore/cloud_firestore.dart';

import '../elements/DrawerWidget.dart';
import '../elements/OrderItemWidget.dart';
import '../elements/OrderNotificationItemWidget.dart';
import '../models/order_noti.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/user_repository.dart' as userRepo;

import '../../generated/l10n.dart';
import '../controllers/order_controller.dart';
import '../elements/EmptyOrdersWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';

class OrdersWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;

  OrdersWidget({Key? key, this.parentScaffoldKey}) : super(key: key);

  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends StateMVC<OrdersWidget> {
  late OrderController _con;

  _OrdersWidgetState() : super(OrderController()) {
    _con = controller as OrderController;
  }

  @override
  void initState() {
    _con.listenForOrders();
    _con.listenForOrderNotification();
    super.initState();
  }
  Widget conversationsList() {
    return StreamBuilder(
      stream: _con.OrderNoti,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var _docs = snapshot.data!.docs;
          print('{_docs : ${_docs}}');

          return _docs.length==0||  userRepo.workingOnOrder.value?
          EmptyOrdersWidget()
              :ListView.separated(
              itemCount:4 ,
              separatorBuilder: (context, index) {
                return SizedBox(height: 7);
              },
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                OrderNotification orderNotification = OrderNotification.fromJson(_docs[index].data() as Map<String, dynamic>);
                return OrderNotificationItemWidget(
                  orderNotification: orderNotification,
                  onTap: () {
                    _con.acceptanceOrderByDriver(orderNotification.id);
                  },
                );
              });
        } else {
          return EmptyOrdersWidget();
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return userRepo.workingOnOrder.value?
    Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey!.currentState!.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context)!.orders,
          style: Theme.of(context).textTheme.headline6!.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshOrders,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10),
          children: <Widget>[
            _con.orders.isEmpty
                ? EmptyOrdersWidget()
                : ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _con.orders.length,
                    itemBuilder: (context, index) {
                      var _order = _con.orders.elementAt(index);
                      return OrderItemWidget(
                          expanded: index == 0 ? true : false,
                          order: _order,
                        onTap: () {
                          _con.cancelOrderByDriver(_order);
                          Navigator.of(context).pop();
                          },


                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 20);
                    },
                  ),
          ],
        ),
      ),

    ):
    Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => _con.scaffoldKey?.currentState?.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context)!.orders,
          style: Theme.of(context).textTheme.headline6!.merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: ListView(
        primary: false,
        children: <Widget>[
          conversationsList(),
        ],
      ),
    );
  }
}
