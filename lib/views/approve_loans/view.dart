import 'package:apploan/views/approve_loans/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';

class ApproveLoansView extends GetView<ApproveLoansController> {
  const ApproveLoansView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Approve Loans',
        onBack: () => Navigator.pop(context, false),
      ),
      body: SafeArea(
        child: Padding(
          padding: UIConstants.spacing.padHorizontal,
          child: Column(
            children: [
              UIConstants.spacing.height,

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.onApprove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Approve',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
