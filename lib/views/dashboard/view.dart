// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:apploan/core/core.dart';
// import 'package:apploan/models/models.dart';
// import 'package:apploan/views/views.dart';

// class DashboardView extends GetView<DashboardController> {
//   const DashboardView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       drawer: const DrawerWidget(),
//       // body: Obx(() {
//       //   if (controller.isLoading.value) {
//       //     return const Center(
//       //       child: CircularProgressIndicator(color: AppColor.red),
//       //     );
//       //   }

//       //   final DashboardModel? dashboard = controller.dashboardModel.value;
//       //   if (dashboard == null) {
//       //     return DashboardWidget();
//       //   }

//       //   return Container(
//       //     child: Column(
//       //       crossAxisAlignment: CrossAxisAlignment.start,
//       //       children: [UIConstants.spacing.height, DashboardWidget()],
//       //     ),
//       //   );
//       // }),
//       body: Stack(
//         children: [
//           // ── Background fills the whole screen ──
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/dashboardbackground.png',
//               fit: BoxFit.cover,
//             ),
//           ),

//           // ── Content ──
//           SafeArea(
//             // child: SingleChildScrollView(
//             child: ConstrainedBox(
//               // Ensures content is at least full screen height
//               // so background image never shows as white gap
//               constraints: BoxConstraints(minHeight: screenHeight),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 10),

//                   // ── Grid menu ──
//                   DashboardWidget(),
//                 ],
//               ),
//             ),
//             // ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';
import 'package:apploan/views/views.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: const DrawerWidget(),
      body: Stack(
        children: [
          // ── Background fills the whole screen ──
          Positioned.fill(
            child: Image.asset(
              'assets/images/dashboardbackground.png',
              fit: BoxFit.cover,
            ),
          ),

          // ── Content ──
          // this is without scroll view
          // SafeArea(
          //   // child: SingleChildScrollView(
          //   child: ConstrainedBox(
          //     // Ensures content is at least full screen height
          //     // so background image never shows as white gap
          //     constraints: BoxConstraints(minHeight: screenHeight),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         const SizedBox(height: 10),

          //         // ── Summary card ──
          //         Obx(
          //           () => DashboardSummaryCard(
          //             activeCOCount: controller.activeCOCount.value,
          //             overdueCOCount: controller.overdueCOCount.value,
          //             loanOutstanding: controller.loanOutstanding.value,
          //             overdueAmount: controller.overdueAmountStr.value,
          //             planCollectionCount: controller.activeCOCount.value,
          //             amountToCollect: controller.totalToCollect.value,
          //             collectedCOCount: controller.collectedCOCount.value,
          //             collectedAmount:
          //                 '${controller.totalCollected.value}/${controller.totalToCollect.value.replaceAll('\$', '')}',
          //             userName: controller.userName.value,
          //           ),
          //         ),
          //         20.height,

          //         // ── Grid menu ──
          //         DashboardWidget(),
          //       ],
          //     ),
          //   ),
          //   // ),
          // ),
          // This is with scroll view
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  Obx(
                    () => DashboardSummaryCard(
                      activeCOCount: controller.activeCOCount.value,
                      overdueCOCount: controller.overdueCOCount.value,
                      loanOutstanding: controller.loanOutstanding.value,
                      overdueAmount: controller.overdueAmountStr.value,
                      planCollectionCount: controller.activeCOCount.value,
                      amountToCollect: controller.totalToCollect.value,
                      collectedCOCount: controller.collectedCOCount.value,
                      collectedAmount:
                          '${controller.totalCollected.value}/${controller.totalToCollect.value.replaceAll('\$', '')}',
                      userName: controller.userName.value,
                    ),
                  ),

                  20.height,

                  DashboardWidget(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
