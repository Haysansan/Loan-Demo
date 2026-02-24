import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';
import 'package:apploan/views/views.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColor.red));
        }

        final DashboardModel? dashboard = controller.dashboardModel.value;
        if (dashboard == null) {
          return DashboardWidget();
        }

        return
          Container(
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UIConstants.spacing.height,
                  DashboardWidget(),
                ],
              ),
          );
      }),
    );
  }
}
