import 'package:apploan/models/disbursement/disbursement.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:intl/intl.dart';

class EndsChildWidget extends StatelessWidget {
  const EndsChildWidget({Key? key, required this.tracking}) : super(key: key);

  final DisbursementListModel tracking;

  String formatCurrency(String amount) {
    return amount != null
        ? NumberFormat.currency(
          locale: 'en_US',
          symbol: '',
        ).format(double.parse(amount)).replaceAll('.00', '')
        : 'N/A';
  }

  // Returns color based on loan_status value
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'waiting verify':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPending = tracking.loan_status.toLowerCase().contains(
      'waiting',
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
          // Orange border for pending cards so they stand out
          color:
              isPending
                  ? Colors.orange.withOpacity(0.6)
                  : Colors.grey.withOpacity(0.2),
          width: isPending ? 1.5 : 1,
        ),
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
            // ── Status badge row ──────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Client name + code
                Expanded(
                  child: ListTile(
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
                  ),
                ),

                // Status chip on the right
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(tracking.loan_status).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _statusColor(tracking.loan_status),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    tracking.loan_status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _statusColor(tracking.loan_status),
                    ),
                  ),
                ),
              ],
            ),

            // ── Loan details ─────────────────────────────
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

            // ── Pending notice ───────────────────────────
            if (isPending) ...[
              8.height,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.hourglass_top_rounded,
                      size: 14,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'រង់ចាំការអនុម័តពី BM / CEO',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
