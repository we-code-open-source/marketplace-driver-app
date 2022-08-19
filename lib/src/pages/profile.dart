import '../elements/StatisticsCarouselWidget.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/profile_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/ProfileAvatarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';

class ProfileWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;

  ProfileWidget({Key? key, this.parentScaffoldKey}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends StateMVC<ProfileWidget> {
  late ProfileController _con;

  _ProfileWidgetState() : super(ProfileController()) {
    _con = controller as ProfileController;
  }

  @override
  void initState() {
    _con.listenForRecentOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).primaryColor),
          onPressed: () => widget.parentScaffoldKey?.currentState?.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context)!.profile,
          style: Theme.of(context).textTheme.headline6!.merge(TextStyle(
              letterSpacing: 1.3, color: Theme.of(context).primaryColor)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).hintColor),
        ],
      ),
      key: _con.scaffoldKey,
      body: _con.user.apiToken == null
          ? CircularLoadingWidget(height: 500)
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ProfileAvatarWidget(
                    user: _con.user,
                    onCamera: () => _con.imgFromCamera(),
                    onGallery: () => _con.imgFromGallery(),
                    image: _con.image,
                  ),

                  Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child:Card(
                    child: SwitchListTile(
                      title: const Text('متوفر'),
                      value: _con.user.driver!.available!,
                      onChanged: (value) => setState(() {
                        _con.user.driver!.available = value;
                        _con.updateDriverState(_con.user.driver!.available);
                      }),
                      secondary: const Icon(Icons.lightbulb_outline),
                    ),
                  ),
                  ),
                  StatisticsCarouselWidget(statistics: _con.statistics),
                ],
              ),
            ),
    );
  }
}
