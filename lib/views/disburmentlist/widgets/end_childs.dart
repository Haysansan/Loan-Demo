import 'package:apploan/models/disbursement/disbursement.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:intl/intl.dart';

class EndsChildWidget extends StatelessWidget {
  const EndsChildWidget({
    Key? key,
    required this.tracking,
  }) : super(key: key);

  final DisbursementListModel tracking;
  String formatCurrency(String amount) {
    // ignore: unnecessary_null_comparison
    return amount != null
        ? '${NumberFormat.currency(locale: 'en_US', symbol: '').format(double.parse(amount))}'.replaceAll('.00', '')
        : 'N/A';
  }
  @override
  Widget build(BuildContext context) {
    return
      Card(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5), // if you need this
          side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
          ),
        ),
        margin: const EdgeInsets.only(left: 13.0, top: 5.0, right: 13.0, bottom: 5.0),
        color: Colors.white,
      child:
        Container(
          padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 0.0, bottom: 10.0),
          child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  leading: Icon(Icons.people_alt),
                  title:
                  Text(
                    tracking.client,
                    style: AppTextStyle.normalPrimarySemiBold,
                  ),
                  subtitle: Text(
                    tracking.client_code,
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),

                Text(
                  'ទឹកប្រាក់កម្ចី: ${ formatCurrency(tracking.principal)}',
                  style: AppTextStyle.smallPrimaryRegular,
                ),
                Text(
                  'មន្រ្ដីឈ្មោ៖: ${tracking.loan_officer}',
                  style: AppTextStyle.smallPrimaryRegular,
                ),
                5.height,
                Text(
                  '${LocaleKeys.location.tr}: ${tracking.villages_name}',
                  style: AppTextStyle.smallPrimaryRegular,
                ),
              ],
          ),
        ),
    );
  }
}
