import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/views/views.dart';
import 'widgets/widgets.dart';

class ApproveLoansView extends GetView<ApproveLoansController> {
  const ApproveLoansView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: CustomAppBar(
          title: controller.currentTitle,
          onBack: () => Navigator.pop(context, false),
        ),
        body: Column(
          children: [
            // ── Tab buttons ───
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: controller.isCEO ? _buildCEOTabs() : _buildBMTabs(),
            ),

            // ── Search bar ───
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.searchCtl,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.searchByCIDName.tr,
                        hintStyle: AppTextStyle.normalLightGreyRegular,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: UIConstants.radius.radiusAll,
                          borderSide: const BorderSide(
                            color: AppColor.lightGrey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: UIConstants.radius.radiusAll,
                          borderSide: const BorderSide(
                            color: AppColor.lightGrey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: UIConstants.radius.radiusAll,
                          borderSide: const BorderSide(
                            color: AppColor.lightGrey,
                          ),
                        ),
                      ),
                      onSubmitted: (_) => controller.search(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 48,
                    width: 48,
                    child: ElevatedButton(
                      onPressed: controller.search,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: UIConstants.radius.radiusAll,
                        ),
                      ),
                      child: const Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // ── Loan list ───
            Expanded(
              child: Builder(
                builder: (_) {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColor.primary),
                    );
                  }

                  final loans = controller.currentList;

                  if (loans.isEmpty) {
                    return NoDataWidget(text: LocaleKeys.searchNotFound.tr);
                  }

                  return RefreshIndicator(
                    color: AppColor.primary,
                    onRefresh: controller.fetchLoans,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: loans.length,
                      itemBuilder: (context, index) {
                        return LoanApprovalCard(
                          loan: loans[index],
                          controller: controller,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── BM: 3 tabs ───
  Widget _buildBMTabs() {
    return Row(
      children: [
        ApproveTabButton(
          count: controller.allCount,
          label: LocaleKeys.viewAllLoans.tr,
          isSelected: controller.selectedTab.value == 0,
          onTap: () => controller.selectedTab.value = 0,
        ),
        const SizedBox(width: 8),
        ApproveTabButton(
          count: controller.verifyCount,
          label: LocaleKeys.verifyLoan.tr,
          isSelected: controller.selectedTab.value == 1,
          isAlert:
              controller.verifyCount > 0 && controller.selectedTab.value != 1,
          onTap: () => controller.selectedTab.value = 1,
        ),
        const SizedBox(width: 8),
        ApproveTabButton(
          count: controller.disbursementCount,
          label: LocaleKeys.disburseLoan.tr,
          isSelected: controller.selectedTab.value == 2,
          isAlert:
              controller.disbursementCount > 0 &&
              controller.selectedTab.value != 2,
          onTap: () => controller.selectedTab.value = 2,
        ),
      ],
    );
  }

  // ── CEO: 2 tabs ───
  Widget _buildCEOTabs() {
    return Row(
      children: [
        ApproveTabButton(
          count: controller.allCount,
          label: LocaleKeys.viewAllLoans.tr,
          isSelected: controller.selectedTab.value == 0,
          onTap: () => controller.selectedTab.value = 0,
        ),
        const SizedBox(width: 8),
        ApproveTabButton(
          count: controller.acceptCount,
          label: LocaleKeys.approveLoan.tr,
          isSelected: controller.selectedTab.value == 1,
          isAlert:
              controller.acceptCount > 0 && controller.selectedTab.value != 1,
          onTap: () => controller.selectedTab.value = 1,
        ),
      ],
    );
  }
}
