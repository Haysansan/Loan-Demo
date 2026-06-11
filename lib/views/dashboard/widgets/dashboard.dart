import 'package:apploan/core/core.dart';
import 'package:apploan/core/resources/locales.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/routes.dart';
import 'package:apploan/views/views.dart';

class DashboardWidget extends StatelessWidget {
  @override
  List catName = [
    // LocaleKeys.loanCalculator.tr,
    LocaleKeys.customers.tr,
    LocaleKeys.loanDisbursments.tr,
    LocaleKeys.repaymentLoan.tr,
    LocaleKeys.prepaid.tr,
    LocaleKeys.datasync.tr,
    LocaleKeys.areaLoan.tr,
    LocaleKeys.writtenoff.tr,
    LocaleKeys.approveLoans.tr,
    LocaleKeys.datatransfer.tr,
    LocaleKeys.received.tr,
    // LocaleKeys.payforearchother.tr,
    // LocaleKeys.deno.tr,
  ];
  List<Color> catColors = [
    // Color(0xFF5DAFF1),
    Color(0xFFF21A3E),
    Color(0xFFF21A3E),
    Color(0xFFF21A3E),
    Color(0xFFF21A3E),
    Color(0xFFF21A3E),
    Color(0xFFF21A3E),
    Color(0xFFF21A3E),
    Color(0xFFF21A3E),
    Color(0xFFF21A3E),
    Color(0xFFF21A3E),
    Color(0xFFF21A3E),
  ];
  List imageList = [
    {"id": 1, "image_path": "assets/images/banner1.png"},
    {"id": 2, "image_path": "assets/images/banner2.png"},
    {"id": 3, "image_path": "assets/images/banner_store.png"},
  ];
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  final List<Widget> catIcons = [
    // Image.asset('assets/images/icon/calculator.png', width: 30, height: 30),
    Image.asset('assets/images/icon/customer.png', width: 30, height: 30),
    Image.asset('assets/images/icon/disburme.png', width: 35, height: 35),
    Image.asset('assets/images/icon/repayment.png', width: 30, height: 30),
    Image.asset('assets/images/icon/prepaid.png', width: 30, height: 30),
    Image.asset('assets/images/icon/sync.png', width: 30, height: 30),
    Image.asset('assets/images/icon/arrear.png', width: 30, height: 30),
    Image.asset('assets/images/icon/writtenoff.png', width: 45, height: 45),
    Image.asset('assets/images/icon/repayment.png', width: 30, height: 30),
    Image.asset('assets/images/icon/transfer.png', width: 30, height: 30),
    Image.asset('assets/images/icon/transfer.png', width: 30, height: 30),
    // Image.asset('assets/images/icon/transfer.png', width: 35, height: 35),
    // Image.asset('assets/images/icon/paidofother.png', width: 35, height: 35),
  ];
  List getReport = ["អតិថិជនបានបង់", "អតិថិជនមិនបានបង់", "អតិថិជនត្រូវប្រមូល"];

  List<Color> getColorsRep = [
    Color(0xFF61BDFD),
    Color(0xFFFC7F7F),
    Color(0xFFCBB4FB),
    // Color(0xFF78E667),
  ];
  List<Icon> getIconsRep = [
    Icon(Icons.paid, color: Colors.white, size: 30),
    Icon(Icons.download_done, color: Colors.white, size: 30),
    Icon(Icons.summarize, color: Colors.white, size: 30),
    // Icon(Icons.approval,color: Colors.white,size: 30),
  ];

  // BM / CEO only see these key indices
  static const _bmCeoIndices = [0, 1, 2, 3, 4, 5, 6, 7, 9];

  (List catNames, List<Color> catColors, List<Widget> catIcons)
  _buildFilteredLists() {
    final user = UserRepository.shared;

    // BM or CEO:
    if (user.isBM || user.isEco) {
      final names = _bmCeoIndices.map((i) => catName[i]).toList();
      final colors = _bmCeoIndices.map((i) => catColors[i]).toList();
      final icons = _bmCeoIndices.map((i) => catIcons[i]).toList();
      return (names, colors, icons);
    }

    // CO:
    if (user.isCO) {
      const coIndices = [0, 1, 2, 3, 4, 5, 6, 7, 8]; // skip 10
      final names = coIndices.map((i) => catName[i]).toList();
      final colors = coIndices.map((i) => catColors[i]).toList();
      final icons = coIndices.map((i) => catIcons[i]).toList();
      return (names, colors, icons);
    }

    // Fallback: show all
    return (catName, catColors, catIcons);
  }

  void RepaymentHandleTap() {
    Get.back();
    Get.toNamed(Routes.repayment);
  }

  void SyncDataHandleTap() {
    Get.back();
    Get.toNamed(Routes.syncData);
  }

  void TransferDataHandleTap() {
    Get.back();
    Get.toNamed(Routes.transferData);
  }

  // void LoanCalculatorHandleTap() {
  //   Get.back();
  //   Get.toNamed(Routes.loancalculator);
  // }

  void LoanDisbursmentsHandleTap() {
    Get.back();
    Get.toNamed(Routes.loandisbursments);
  }

  void AreaLoanHandleTap() {
    Get.back();
    Get.toNamed(Routes.arealoan);
  }

  void WrittenOffHandleTap() {
    Get.back();
    Get.toNamed(Routes.writtenoff);
  }

  void PrePaidHandleTap() {
    Get.back();
    Get.toNamed(Routes.prepaid);
  }

  void PayForEeachOtherHandleTap() {
    Get.back();
    Get.toNamed(Routes.payforeachother);
  }

  void CustomersHandleTap() {
    Get.delete<CustomersController>(force: true);
    Get.back();
    Get.toNamed(Routes.customers);
  }

  // void moneyCount() {
  //   Get.back();
  //   Get.toNamed(Routes.dino);
  // }

  void Approval() {
    Get.back();
    Get.toNamed(Routes.approveLoans)?.then((_) {
      // Refresh badge count when user comes back
      Get.find<DashboardController>().fetchPendingApprovalCount();
    });
  }

  void ReceivedDataHandleTap() {
    Get.back();
    Get.toNamed(Routes.received);
  }
  // void Approval() {
  //   Get.back(); // close drawer or whatever
  //   Get.toNamed(Routes.approveLoans);
  //   // ← remove the .then() entirely, no callback needed
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.65),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
      ),
      child: Obx(() {
        // Rebuild when permission changes
        final _ = UserRepository.shared.permission;

        // Get filtered menu items
        final (catNames, catColors, catIcons) = _buildFilteredLists();

        return Stack(
          children: [
            Positioned(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 25, left: 1, right: 1),
                  child: Column(
                    children: [
                      GridView.builder(
                        itemCount: catNames.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.3,
                        ),
                        itemBuilder: (context, index) {
                          // For future use: if some features are coming soon, we can disable them here based on their index or name
                          // final isComingSoon =
                          //     catNames[index] == LocaleKeys.prepaid.tr;
                          final isComingSoon =
                              false; //right now no unavailable features]
                          // for icon restriction
                          final isRestricted =
                              catNames[index] == LocaleKeys.approveLoans.tr &&
                              UserRepository.shared.isCO;
                          return InkWell(
                            onTap: () {
                              if (catNames[index] == LocaleKeys.customers.tr) {
                                CustomersHandleTap();
                              } else if (catNames[index] ==
                                  LocaleKeys.loanDisbursments.tr) {
                                LoanDisbursmentsHandleTap();
                              } else if (catNames[index] ==
                                  LocaleKeys.repaymentLoan.tr) {
                                RepaymentHandleTap();
                              } else if (catNames[index] ==
                                  LocaleKeys.prepaid.tr) {
                                PrePaidHandleTap();
                              } else if (catNames[index] ==
                                  LocaleKeys.datasync.tr) {
                                SyncDataHandleTap();
                              } else if (catNames[index] ==
                                  LocaleKeys.areaLoan.tr) {
                                AreaLoanHandleTap();
                              } else if (catNames[index] ==
                                  LocaleKeys.writtenoff.tr) {
                                WrittenOffHandleTap();
                              } else if (catNames[index] ==
                                  LocaleKeys.approveLoans.tr) {
                                if (UserRepository.shared.isCO) {
                                  DialogManager.showDialog(
                                    title: "Access Denied",
                                    subTitle:
                                        "This feature is not available for COs.",
                                  );
                                  return;
                                }

                                Approval();
                              } else if (catNames[index] ==
                                  LocaleKeys.datatransfer.tr) {
                                TransferDataHandleTap();
                              } else if (catNames[index] ==
                                  LocaleKeys.received.tr) {
                                ReceivedDataHandleTap();
                              }
                              // else if (catNames[index] ==
                              //     LocaleKeys.deno.tr) {
                              //   moneyCount();
                              // }
                              else {
                                DialogManager.showDialog(
                                  title: LocaleKeys.commingSoon.tr,
                                  subTitle: LocaleKeys.futureUpdate.tr,
                                );
                              }
                            },
                            child: Ink(
                              child: Column(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        height: 55,
                                        width: 55,
                                        decoration: BoxDecoration(
                                          color:
                                              isComingSoon
                                                  ? const Color(0xFFA88787)
                                                  : catColors[index],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(child: catIcons[index]),
                                      ),
                                      Container(
                                        height: 55,
                                        width: 55,
                                        decoration: BoxDecoration(
                                          color:
                                              isRestricted
                                                  ? const Color.fromARGB(
                                                    255,
                                                    255,
                                                    184,
                                                    184,
                                                  )
                                                  : catColors[index],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(child: catIcons[index]),
                                      ),
                                      if (catNames[index] ==
                                          LocaleKeys.approveLoans.tr)
                                        Obx(() {
                                          final count =
                                              Get.find<DashboardController>()
                                                  .pendingApprovalCount
                                                  .value;
                                          if (count <= 0)
                                            return const SizedBox.shrink();
                                          return Positioned(
                                            top: -4,
                                            right: -4,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              constraints: const BoxConstraints(
                                                minWidth: 20,
                                                minHeight: 20,
                                              ),
                                              decoration: const BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                '$count',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1,
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    catNames[index],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
