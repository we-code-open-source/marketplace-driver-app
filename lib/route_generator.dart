import 'package:deliveryboy/src/pages/chat.dart';
import 'package:deliveryboy/src/pages/code_view.dart';
import 'package:deliveryboy/src/pages/forceUpdateView.dart';
import 'package:deliveryboy/src/pages/order_not.dart';
import 'package:deliveryboy/src/pages/reset_password.dart';
import 'package:flutter/material.dart';

import 'src/models/route_argument.dart';
import 'src/pages/forget_password.dart';
import 'src/pages/help.dart';
import 'src/pages/languages.dart';
import 'src/pages/login.dart';
import 'src/pages/notifications.dart';
import 'src/pages/order.dart';
import 'src/pages/pages.dart';
import 'src/pages/permissionView.dart';
import 'src/pages/settings.dart';
import 'src/pages/signup.dart';
import 'src/pages/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/Permission':
        return MaterialPageRoute(builder: (_) => PermissionView());
      case '/SignUp':
        return MaterialPageRoute(builder: (_) => SignUpWidget(routeArgument: args as RouteArgument));
      case '/MobileVerification':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/MobileVerification2':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/Chat':
        return MaterialPageRoute(builder: (_) => ChatWidget(routeArgument: args as RouteArgument));
      case '/ForceUpdate':
        return MaterialPageRoute(builder: (_) => ForceUpdateView(routeArgument: args as RouteArgument));
      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginWidget());
      case '/ForgetPassword':
        return MaterialPageRoute(builder: (_) => ForgetPasswordWidget(routeArgument: args as RouteArgument));
      case '/ResetPassword':
        return MaterialPageRoute(builder: (_) => ResetPasswordWidget(routeArgument: args as RouteArgument));
      case '/code':
        return MaterialPageRoute(builder: (_) => CodeView(routeArgument: args as RouteArgument));
      case '/Pages':
        return MaterialPageRoute(builder: (_) => PagesTestWidget(currentTab: args));
      case '/OrderDetails':
        return MaterialPageRoute(builder: (_) => OrderWidget(routeArgument: args as RouteArgument));
        case '/OrderDetailsNot':
        return MaterialPageRoute(builder: (_) => OrderNotWidget(routeArgument: args as RouteArgument));
      case '/Notifications':
        return MaterialPageRoute(builder: (_) => NotificationsWidget());
      case '/Languages':
        return MaterialPageRoute(builder: (_) => LanguagesWidget());
      case '/Help':
        return MaterialPageRoute(builder: (_) => HelpWidget());
      case '/Settings':
        return MaterialPageRoute(builder: (_) => SettingsWidget());
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(builder: (_) => Scaffold(body: SafeArea(child: Text('Route Error'))));
    }
  }
}
