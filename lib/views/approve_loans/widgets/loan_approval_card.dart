import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';
import 'package:apploan/views/views.dart';

/// The card displayed for each loan in the approval list.
class LoanApprovalCard extends StatelessWidget {
  const LoanApprovalCard({
    Key? key,
    required this.loan,
    required this.controller,
  }) : super(key: key);

  final LoanApprovalModel loan;
  final ApproveLoansController controller;

  String _formatAmount(String raw) {
    final num? value = num.tryParse(raw);
    if (value == null) return raw;
    return '${NumberFormat('#,###').format(value)} ៛';
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return AppColor.red;
      default:
        return Colors.grey;
    }
  }

  /// Routes approve/reject to the correct controller method based on role + tab.
  void _onApprove() {
    if (controller.isCEO) {
      controller.approveLoan(loan);
    } else if (controller.selectedTab.value == 1) {
      // BM – Verify tab
      controller.verifyLoan(loan);
    } else {
      // BM – Disbursement tab
      controller.disburseLoan(loan);
    }
  }

  void _onReject() {
    if (controller.isCEO) {
      controller.rejectLoan(loan);
    } else if (controller.selectedTab.value == 1) {
      // BM – Verify tab
      controller.rejectVerifyLoan(loan);
    } else {
      // BM – Disbursement tab
      controller.rejectDisbursement(loan);
    }
  }

  /// View All tab (tab 0) shows completed loans — no action buttons needed.
  bool get _showActions => controller.selectedTab.value != 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: UIConstants.radius.radiusAll,
        border: Border.all(color: AppColor.lightGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: avatar | name + branch + date | status badge ───
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColor.lightGrey,
                  child: ClipOval(
                    child: CustomNetworkImage(
                      imageUrl: loan.photo,
                      width: 56,
                      height: 56,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loan.client,
                        style: AppTextStyle.normalPrimarySemiBold,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Branch: ${loan.branch}',
                        style: AppTextStyle.smallGreyRegular,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Village: ${loan.village}',
                        style: AppTextStyle.smallGreyRegular,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: _statusColor(loan.status)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    loan.status,
                    style: TextStyle(
                      color: _statusColor(loan.status),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const DarkGreyDivider(),

          // ── Credit Officer ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: RichText(
              text: TextSpan(
                style: AppTextStyle.normalPrimaryRegular,
                children: [
                  const TextSpan(text: 'Credit Officer: '),
                  TextSpan(
                    text: loan.creditOfficer,
                    style: AppTextStyle.normalPrimarySemiBold,
                  ),
                ],
              ),
            ),
          ),
          const DarkGreyDivider(),

          // ── Loan details grid (2 × 2) ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    _detailCell(
                      label: 'Loan amount',
                      value: _formatAmount(loan.loanAmount),
                      valueColor: AppColor.red,
                      valueBold: true,
                    ),
                    _detailCell(
                      label: 'Interest rate',
                      value: loan.interestRate,
                      valueBold: true,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _detailCell(
                      label: 'Created on',
                      value: loan.createAt,
                      valueBold: true,
                    ),
                    _detailCell(
                      label: 'Cycle / Frequency',
                      value: '${loan.cycle} / (${loan.frequency})',
                      valueBold: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const DarkGreyDivider(),

          // ── Product name ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(loan.productName, style: AppTextStyle.smallGreyRegular),
          ),

          // ── Comment + action buttons (hidden on View All tab) ──
          if (_showActions) ...[
            const DarkGreyDivider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: TextField(
                controller: controller.getCommentController(loan.id),
                decoration: InputDecoration(
                  hintText: 'Add a comment',
                  hintStyle: AppTextStyle.normalLightGreyRegular,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: UIConstants.radius.radiusAll,
                    borderSide: const BorderSide(color: AppColor.lightGrey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: UIConstants.radius.radiusAll,
                    borderSide: const BorderSide(color: AppColor.lightGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: UIConstants.radius.radiusAll,
                    borderSide: const BorderSide(color: AppColor.lightGrey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 14),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _onApprove,
                      icon: const Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 18,
                      ),
                      label: Text(
                        controller.isBM && controller.selectedTab.value == 2
                            ? LocaleKeys.disburseLoan.tr
                            : 'Approve',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Colors.green, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: UIConstants.radius.radiusAll,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _onReject,
                      icon: const Icon(
                        Icons.close,
                        color: AppColor.red,
                        size: 18,
                      ),
                      label: const Text(
                        'Reject',
                        style: TextStyle(
                          color: AppColor.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColor.red, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: UIConstants.radius.radiusAll,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailCell({
    required String label,
    required String value,
    Color? valueColor,
    bool valueBold = false,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyle.smallGreyRegular),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: valueBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? AppColor.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
