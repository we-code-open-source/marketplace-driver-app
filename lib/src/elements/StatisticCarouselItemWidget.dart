import 'package:flutter/material.dart';

import '../helpers/helper.dart';

class StatisticCarouselItemWidget extends StatelessWidget {
  final double? amount;
  final String? title;

  StatisticCarouselItemWidget({Key? key, this.title, this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 2)),
        ],
      ),
      width: 150,
      height: 130,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Helper.of(context).trans(title!),
            textAlign: TextAlign.center,
            maxLines: 3,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 8),
          title != 'total_orders'
              ? Text('${amount?.toStringAsFixed(2)} دل',
                  style: Theme.of(context).textTheme.headline2!.merge(
                        TextStyle(height: 1),
                      ))
              : Text('${amount?.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.headline2!.merge(
                        TextStyle(height: 1),
                      )),
        ],
      ),
    );
  }
}
