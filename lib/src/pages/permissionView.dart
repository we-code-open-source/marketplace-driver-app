import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;

class PermissionView extends StatelessWidget {
  PermissionView({Key? key}) : super(key: key);

  final Widget _imageWidget = Container(
    width: 150,
    height: 150,
    child: Image.asset(
      'assets/img/location.png',
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
                        Text('استخدم موقعك',
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

                        Container(
                            height: 100,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text(
                                  'سابق شريك يسمح بالوصول إلى موقعك الحالي وكذلك في الخلفية لكي يتم تعقب حركتك و ارسال الطلبات القريبة اليك.',
                                  maxLines: 4,
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
                              'سياسية الخصوصية',
                              style: Theme.of(context)
                                  .textTheme
                                  .button!
                                  .copyWith(color: Colors.white),
                            ),
                            onPressed: () async {
                              await launch(Privacy_Policy);
                            },
                          ),
                        ),
                        SizedBox(height: 100,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 150,
                             child: MaterialButton(
                                color: Theme.of(context).primaryColor,
                                height: 45,
                                minWidth: double.infinity,
                                shape: const BeveledRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(7.0)),
                                ),
                                child: Text(
                                  'غير موافق',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .copyWith(
                                      color: Theme.of(context).accentColor),
                                ),
                                onPressed: () async {
                                  SystemChannels.platform
                                      .invokeMethod('SystemNavigator.pop');
                                },
                              ),
                            ),
                            Container(
                              width: 100,
                             child: MaterialButton(
                                color: Theme.of(context).accentColor,
                                height: 45,
                                minWidth: double.infinity,
                                shape: const BeveledRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7.0)),
                                ),
                                child: Text(
                                  'موافق',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .copyWith(color: Colors.white),
                                ),
                                onPressed: () async {
                                  if (currentUser.value.apiToken == null) {
                                    Navigator.of(context)
                                        .pushReplacementNamed('/Login');
                                  } else {
                                    settingRepo.versionCheck(context);
                                  }
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ))
              ],
            )));
  }
}
