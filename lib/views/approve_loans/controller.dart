import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApproveLoansController extends GetxController {
  void onApprove() {
    Get.snackbar(
      'Success',
      'Loan approved successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
