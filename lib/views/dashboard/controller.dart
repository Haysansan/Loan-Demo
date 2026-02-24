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

  DatePicker getDatePicker() {
    final DatePicker startPicker = DatePicker(
      controller: dateCtl,
      initialDate: dateCtl.text.isEmpty
          ? DateTime.parse('${DateFormat("yyyy-MM-dd").format(DateTime.now())} 00:00:00')
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
  void onClose() {
    dateCtl.dispose();
    super.onClose();
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
