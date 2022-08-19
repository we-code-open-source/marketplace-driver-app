import '../elements/EmptyOrdersWidget.dart';
import 'package:flutter/cupertino.dart';

import '../controllers/order_controller.dart';
import '../models/order_noti.dart';
import '../elements/OrderNotificationItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/user_repository.dart' as userRepo;

import '../../generated/l10n.dart';
import '../elements/DrawerWidget.dart';

class OrderNotificationsWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;

  OrderNotificationsWidget({Key? key, this.parentScaffoldKey}) : super(key: key);

  @override
  _OrderNotificationsWidgetState createState() => _OrderNotificationsWidgetState();
}

class _OrderNotificationsWidgetState extends StateMVC<OrderNotificationsWidget> {
  late OrderController _con;
  _OrderNotificationsWidgetState() : super(OrderController()) {
    _con = controller as OrderController;
  }
  @override
  void initState() {
    _con.listenForOrderNotification();

    super.initState();
  }

  Widget conversationsList() {
    return StreamBuilder(
      stream: _con.OrderNoti,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var _docs = snapshot.data!;
return Text("Almslaty");
          // return _docs.length==0 || userRepo.workingOnOrder.value?
          //     EmptyOrdersWidget()
          //  :ListView.separated(
          //     itemCount: _docs.length,
          //     separatorBuilder: (context, index) {
          //       return SizedBox(height: 7);
          //     },
          //     shrinkWrap: true,
          //     primary: false,
          //     itemBuilder: (context, index) {
          //       OrderNotification orderNotification = OrderNotification.fromJson(_docs[index].data());
          //       return OrderNotificationItemWidget(
          //         orderNotification: orderNotification,
          //         onTap: () {
          //           _con.acceptanceOrderByDriver(orderNotification.id);
          //           },
          //       );
          //     });
        } else {
          return EmptyOrdersWidget();
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
