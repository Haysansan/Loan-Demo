import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:apploan/core/core.dart';

class DashboardSummaryCard extends StatelessWidget {
  const DashboardSummaryCard({
    Key? key,
    required this.activeCOCount,
    required this.overdueCOCount,
    required this.loanOutstanding,
    required this.overdueAmount,
    required this.planCollectionCount,
    required this.amountToCollect,
    required this.collectedCOCount,
    required this.collectedAmount,
    this.userName = '',
    this.companyName = 'Soft Creative CO.,LTD',
  }) : super(key: key);

  final int activeCOCount;
  final int overdueCOCount;
  final String loanOutstanding;
  final String overdueAmount;
  final int planCollectionCount;
  final String amountToCollect;
  final int collectedCOCount;
  final String collectedAmount; // formatted as "$4,000/$5,000"
  final String userName;
  final String companyName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.20),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.6),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          AssetPath.appLogo.path,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    12.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            companyName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          4.height,
                          Text(
                            'Hi, ${userName.isNotEmpty ? userName : 'User'}! Welcome to SC Loan.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                8.height,

                // ── Row 1: Active CO | Overdue CO ──
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        title: 'Active CO: $activeCOCount',
                        sublabel: 'Loan Outstanding',
                        amount: loanOutstanding,
                        // khrAmount: loanOutstandingKhr,
                      ),
                    ),
                    16.width,
                    Expanded(
                      child: _StatBox(
                        title: 'Overdue CO: $overdueCOCount',
                        sublabel: 'Overdue Amount',
                        amount: overdueAmount,
                        // khrAmount: overdueAmountKhr,
                      ),
                    ),
                  ],
                ),

                8.height,

                // ── Row 2: Plan Collection | Collected ──
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        title: 'Plan Collection: $planCollectionCount',
                        sublabel: 'Amount To Collect',
                        amount: amountToCollect,
                        // khrAmount: amountToCollectKhr,
                      ),
                    ),
                    16.width,
                    Expanded(
                      child: _StatBox(
                        title:
                            'Collected: $collectedCOCount/$planCollectionCount',
                        sublabel: 'Collected Amount',
                        amount: collectedAmount,
                        // khrAmount: collectedAmountKhr,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.title,
    required this.sublabel,
    required this.amount,
    // this.khrAmount,
  });

  final String title;
  final String sublabel;
  final String amount;
  // final String? khrAmount;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              2.height,
              Text(
                sublabel,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 12,
                ),
              ),
              4.height,
              Text(
                amount,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Uncomment to show KHR equivalent:
              // if (khrAmount != null) ...[
              //   2.height,
              //   Text(
              //     khrAmount!,
              //     style: TextStyle(
              //       color: Colors.white.withOpacity(0.8),
              //       fontSize: 14,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }
}
