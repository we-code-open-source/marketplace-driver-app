import 'dart:io';
import 'package:deliveryboy/src/models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../repository/settings_repository.dart';

class ForceUpdateView extends StatelessWidget {
  final RouteArgument? routeArgument;

  ForceUpdateView({Key? key, this.routeArgument}) : super(key: key);

  final Widget _imageWidget = Container(
    width: 90,
    height: 90,
    child: Image.asset(
      'assets/img/logo.png',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return true;
        },
        child: Container(
            height: 100,
            color: Theme.of(context).primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 80,
                        ),
                        _imageWidget,
                        const SizedBox(
                          height: 16,
                        ),
                        Text('سابق شريك',
                            style: Theme.of(context).textTheme.headline5),
                      ],
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        const SizedBox(
                          height: 32,
                        ),
                        Text(
                            Platform.isIOS
                                ? setting.value.appVersionIOS!
                                : setting.value.appVersionAndroid!,
                            style: Theme.of(context).textTheme.subtitle1),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                            height: 100,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text(
                                  'يتوفر إصدار أحدث من التطبيق ، يرجى تحديثه الآن.',
                                  maxLines: 9,
                                  style: Theme.of(context).textTheme.bodyText1),
                            )),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 32, right: 32),
                          child: MaterialButton(
                            color: Theme.of(context).accentColor,
                            height: 45,
                            minWidth: double.infinity,
                            shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0)),
                            ),
                            child: Text(
                              'تحديث الان',
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  !.copyWith(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (Platform.isIOS) {
                                await launch(APP_STORE_URL);
                              } else if (Platform.isAndroid) {
                                  await launch(PLAY_STORE_URL);
                              }
                            },
                          ),
                        ),
                        routeArgument!.id!.isNotEmpty
                            ? Container(
                                margin:
                                    const EdgeInsets.only(left: 32, right: 32),
                                child: MaterialButton(
                                  color: Theme.of(context).primaryColor,
                                  height: 45,
                                  minWidth: double.infinity,
                                  shape: const BeveledRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7.0)),
                                  ),
                                  child: Text(
                                    'في وقت لاحق',
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        !.copyWith(
                                            color:
                                                Theme.of(context).accentColor),
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).pushReplacementNamed(
                                        '/Pages',
                                        arguments:
                                            int.tryParse(routeArgument!.id!));
                                  },
                                ),
                              )
                            : SizedBox(),
                      ],
                    ))
              ],
            )));
  }
}
