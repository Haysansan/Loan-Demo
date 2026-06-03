import 'package:apploan/models/disbursement/disbursement.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:intl/intl.dart';

class EndsChildWidget extends StatelessWidget {
  const EndsChildWidget({Key? key, required this.tracking}) : super(key: key);

  final DisbursementListModel tracking;
  String formatCurrency(String amount) {
    // ignore: unnecessary_null_comparison
    return amount != null
        ? '${NumberFormat.currency(locale: 'en_US', symbol: '').format(double.parse(amount))}'
            .replaceAll('.00', '')
        : 'N/A';
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      margin: const EdgeInsets.only(
        left: 13.0,
        top: 5.0,
        right: 13.0,
        bottom: 5.0,
      ),
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.only(
          left: 10.0,
          top: 10.0,
          right: 10.0,
          bottom: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.people_alt),
              title: Text(
                tracking.client,
                style: AppTextStyle.normalPrimarySemiBold,
              ),
              subtitle: Text(
                tracking.client_code,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _statusColor(tracking.status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _statusColor(tracking.status),
                    width: 1,
                  ),
                ),
                child: Text(
                  tracking.status,
                  style: TextStyle(
                    color: _statusColor(tracking.status),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Text(
              'ទឹកប្រាក់កម្ចី: ${formatCurrency(tracking.principal)}',
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
