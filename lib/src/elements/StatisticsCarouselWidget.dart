import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../elements/StatisticsCarouselLoaderWidget.dart';
import '../models/statistic.dart';
import 'StatisticCarouselItemWidget.dart';

class StatisticsCarouselWidget extends StatelessWidget {
  final Statistics statistics;

  StatisticsCarouselWidget({Key? key, required this.statistics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return statistics.settlements!.amount!.isEmpty&&statistics.settlements!.amount==null
        ? StatisticsCarouselLoaderWidget()
        : Container(
            color: Theme.of(context).primaryColor.withOpacity(0.7),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StatisticCarouselItemWidget(
                      title: 'total_orders',
                      amount: double.tryParse(statistics.settlements!.count!)! + double.tryParse(statistics.availabelOrdersForSettlement!.count!)!,
                    ),
                    StatisticCarouselItemWidget(
                      title: 'total_earning_after',
                      amount: double.tryParse(statistics.settlements!.delivery_fee!)!-double.tryParse(statistics.settlements!.amount!)!,
                    ),

                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StatisticCarouselItemWidget(
                      title: 'company_ratio',
                      amount: double.tryParse(statistics.availabelOrdersForSettlement!.fee!),
                    ),
                    StatisticCarouselItemWidget(
                      title: 'total_earning_before',
                      amount:  double.tryParse(statistics.availabelOrdersForSettlement!.delivery_fee!)!-double.tryParse(statistics.availabelOrdersForSettlement!.fee!)!,
                    ),

                  ],
                ),
                SizedBox(height: 10,),
                StatisticCarouselItemWidget(
                  title: 'coupons',
                  amount: double.tryParse(statistics.availabelOrdersForSettlement!.amountRestaurantCoupons!)!
                      +double.tryParse(statistics.availabelOrdersForSettlement!.amountDeliveryCoupons!)!,
                ),
              ],
            ));
  }
}
