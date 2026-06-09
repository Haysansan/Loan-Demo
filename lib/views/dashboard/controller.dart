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

  final ReasonController reasonCtl = Get.find<ReasonController>();
  final StartController startCtl = Get.find<StartController>();

  final RxList<BookingModel> bookings = <BookingModel>[].obs;

  // For pending approval count
  final RxInt pendingApprovalCount = 0.obs;

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
