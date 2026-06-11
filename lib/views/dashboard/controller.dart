import 'package:apploan/core/offline/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/flavor/flavor.dart';
import 'package:apploan/models/models.dart';
import 'package:apploan/views/views.dart';

class DashboardController extends GetxController {
  final TextEditingController dateCtl = TextEditingController();

  final Rxn<DashboardModel> dashboardModel = Rxn<DashboardModel>();
  final RxBool isLoading = false.obs;
  final RxString userName = ''.obs;
  final RxBool hasSyncedData = false.obs;

  final ReasonController reasonCtl = Get.find<ReasonController>();
  final StartController startCtl = Get.find<StartController>();

  final RxList<BookingModel> bookings = <BookingModel>[].obs;

  // For pending approval count
  final RxInt pendingApprovalCount = 0.obs;

  // for summary card
  final RxInt activeCOCount = 0.obs;
  final RxInt overdueCOCount = 0.obs;
  final RxString loanOutstanding = '\$0.00'.obs;
  final RxString overdueAmountStr = '\$0.00'.obs;
  final RxInt collectedCOCount = 0.obs;
  final RxString totalToCollect = '\$0.00'.obs;
  final RxString totalCollected = '\$0.00'.obs;
  final RxString totalToCollectKhr = '0៛'.obs;
  final RxString totalCollectedKhr = '0៛'.obs;
  final RxDouble collectedSum = 0.0.obs;
  final RxDouble totalRepaymentSum = 0.0.obs;
  final RxDouble exchangeRate = 4100.0.obs;

  // ── Format helpers ───
  String _formatUsd(double amount) {
    return '\$${NumberFormat('#,##0.00').format(amount)}';
  }

  String _formatKhr(double amount) {
    return '${NumberFormat('#,###').format(amount)}៛';
  }

  DatePicker getDatePicker() {
    final DatePicker startPicker = DatePicker(
      controller: dateCtl,
      initialDate:
          dateCtl.text.isEmpty
              ? DateTime.parse(
                '${DateFormat("yyyy-MM-dd").format(DateTime.now())} 00:00:00',
              )
              : DateTime.parse(dateCtl.text),
      minDate: DateTime(DateTime.now().year - 200),
      maxDate: DateTime(DateTime.now().year + 200),
      minYear: DateTime.now().year - 200,
      maxYear: DateTime.now().year + 200,
    );
    return startPicker;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    fetchPendingApprovalCount(); // always call to update count on dashboard
  }

  @override
  void onClose() {
    dateCtl.dispose();
    super.onClose();
  }

  // ── Load user name from SharedPreferences ───
  Future<void> _loadUserName() async {
    try {
      final raw = await SharedPreferencesManager.get('user_name');
      final name = raw?.toString() ?? '';
      userName.value = name.isNotEmpty ? name : 'User';
    } catch (_) {
      userName.value = 'User';
    }
  }

  Future<void> fetchSummaryAmounts() async {
    try {
      final List<RepaymentModel> toCollectRows = await DatabaseHelper.instance
          .queryAllRowsRepayments(1);

      hasSyncedData.value = toCollectRows.isNotEmpty;
      if (!hasSyncedData.value) return;

      final double rate = exchangeRate.value;

      // Plan totals — sum of total_repayment (stored in KHR)
      final double toCollectSum = toCollectRows.fold(
        0.0,
        (prev, item) => prev + (double.tryParse(item.total_repayment) ?? 0.0),
      );

      // Overdue — rows where arrears (arrea) > 0
      final List<RepaymentModel> overdueRows =
          toCollectRows
              .where((item) => (double.tryParse(item.arrea) ?? 0.0) > 0)
              .toList();
      final double overdueSum = overdueRows.fold(
        0.0,
        (prev, item) => prev + (double.tryParse(item.total_repayment) ?? 0.0),
      );

      // Collected
      final List<PaymentModel> collectedRows =
          await DatabaseHelper.instance.queryAllRowsCollected();
      final double collected = collectedRows.fold(
        0.0,
        (prev, item) => prev + (double.tryParse(item.total_repayment) ?? 0.0),
      );

      activeCOCount.value = toCollectRows.length;
      overdueCOCount.value = overdueRows.length;
      loanOutstanding.value = _formatUsd(toCollectSum / rate);
      overdueAmountStr.value = _formatUsd(overdueSum / rate);
      collectedCOCount.value = collectedRows.length;

      totalRepaymentSum.value = toCollectSum;
      collectedSum.value = collected;
      totalToCollect.value = _formatUsd(toCollectSum / rate);
      totalCollected.value = _formatUsd(collected / rate);
      totalToCollectKhr.value = _formatKhr(toCollectSum);
      totalCollectedKhr.value = _formatKhr(collected);
    } catch (_) {}
  }

  Future<void> fetchPendingApprovalCount() async {
    pendingApprovalCount.value = 0;
    if (!UserRepository.shared.isBM && !UserRepository.shared.isEco) return;
    try {
      final branchId = await SharedPreferencesManager.getIntValue('branch_id');
      final userId = await SharedPreferencesManager.getIntValue('user_id');

      final res = await Get.find<ApiService>().get(
        EndPoints.getApproveDisburse,
        queryParameters: {'branch_id': branchId, 'user_id': userId},
        isShowLoading: false,
      );

      final raw = getPropertyFromJson(res.data, 'data');
      if (raw is! List) return;

      if (UserRepository.shared.isBM) {
        pendingApprovalCount.value =
            raw
                .where(
                  (e) =>
                      e['status'] == 'submitted' || e['status'] == 'approved',
                )
                .length;
      } else if (UserRepository.shared.isEco) {
        pendingApprovalCount.value =
            raw.where((e) => e['status'] == 'pending').length;
      }
    } catch (_) {}
  }

  void gridHandleTap(DeliveryStatus status) {
    // To prevent onInit execute
    if (!AppConfig.shared.isDeliveryTapOpened) {
      AppConfig.shared.isDeliveryTapOpened = true;
    }

    int deliveryStatus = 0;
    switch (status) {
      case DeliveryStatus.success:
        deliveryStatus = 3;
        break;
      case DeliveryStatus.inProgress:
        deliveryStatus = 1;
        break;
      case DeliveryStatus.problem:
        deliveryStatus = 5;
        break;
      default:
    }

    startCtl.changeMenu(
      3,
      isFromGrid: true,
      dateFilter: dateCtl.text,
      deliveryStatus: deliveryStatus,
    );
  }

  void clearDateFilter() {
    dateCtl.text = '';
  }
}
