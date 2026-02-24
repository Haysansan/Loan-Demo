import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/views/views.dart';

dynamic _tapFunction({required index}) {
  switch (index) {
    case 0:
      return DialogManager.showCustom(DashboardFilterDialog());
    case 1:
      return DialogManager.showCustom(DateFilterDialog());
    case 3:
      return DialogManager.showCustom(DeliveryFilterDialog());
  }
}

PreferredSizeWidget appBarWidget() {
  final StartController startCtl = Get.find<StartController>();

  return AppBar(
    title: Obx(() => Text(startCtl.getTitle())),
    elevation: 0,
    actions: [
      Obx(() {
        if (startCtl.selectedIndex.value != 2 && startCtl.selectedIndex.value != 4) {
          return Padding(
            padding: 15.padRight,
            child: InkWell(
              child: const Icon(Icons.notifications),
              onTap: () => _tapFunction(index: startCtl.selectedIndex.value),
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    ],
  );
}
