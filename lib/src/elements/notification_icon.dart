import 'package:flutter/material.dart';

import '../helpers/sabek_icons.dart';

class NotificationIcon extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: new BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(SabekIcons.bell1,color: Theme.of(context).hintColor, size: 20),

        ),
      ),
    );
  }
}