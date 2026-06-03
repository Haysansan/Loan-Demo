import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/views/views.dart';

class PaymentCollectionView extends GetView<PaymentListController> {
  const PaymentCollectionView({Key? key}) : super(key: key);

  @override
  void onSearch() async {
    if (controller.formKey.currentState?.validate() ?? false) {
      await controller.fetchpaymentList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCO = UserRepository.shared.isCO;

    return Scaffold(
      appBar: CustomAppBar(
        title: LocaleKeys.paymentslist.tr,
        onBack: () {
          final startCtl = Get.find<StartController>();
          startCtl.changeMenu(startCtl.previousIndex.value);
        },
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: TotalPackageWidget(
                icon: Icons.people_alt,
                packages:
                    '${controller.totalClient.text} ${LocaleKeys.clients.tr}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: TotalIncomeWidget(codKhr: controller.totalAmount.text),
            ),
            UIConstants.spacing.height,

            // Search
            Padding(
              padding: UIConstants.spacing.padHorizontal,
              child: Row(
                children: [
                  Expanded(
                    child: Form(
                      key: controller.formKey,
                      child: CustomTextField(
                        controller: controller.searchCtl,
                        hintText: LocaleKeys.searchByCIDName.tr,
                        readOnly: !isCO,
                        validator: (t) => isCO ? FormValidator.empty(t) : null,
                      ),
                    ),
                  ),
                  if (isCO) ...[
                    const SizedBox(width: 10),
                    PrimaryButton(
                      text: LocaleKeys.search.tr.toUpperCase(),
                      width: 100,
                      onPressed: onSearch,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10),

            if (!isCO) _TabSwitcher(controller: controller),

            if (isCO)
              _CoList(controller: controller)
            else
              _BmList(controller: controller),
          ],
        );
      }),
    );
  }
}

// Tab switcher
class _TabSwitcher extends StatelessWidget {
  const _TabSwitcher({required this.controller});
  final PaymentListController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedTab.value;
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _TabItem(
                  label: 'Pay Lists',
                  isSelected: selected == 'paylist',
                  onTap: () => controller.switchTab('paylist'),
                ),
              ),
              Expanded(
                child: _TabItem(
                  label: 'Repayments',
                  isSelected: selected == 'repayment',
                  onTap: () => controller.switchTab('repayment'),
                ),
              ),
            ],
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
        ],
      );
    });
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColor.red : AppColor.darkGrey;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              const SizedBox(width: 3),
              Icon(
                isSelected ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: color,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            color: isSelected ? AppColor.red : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

// CO list
class _CoList extends StatelessWidget {
  const _CoList({required this.controller});
  final PaymentListController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.isDone && controller.repayment.isEmpty) {
        return NoDataWidget(text: LocaleKeys.searchNotFound.tr);
      }

      return Expanded(
        child: ListView.builder(
          padding: UIConstants.spacing.padHorizontal,
          itemCount: controller.repayment.length,
          itemBuilder:
              (ctx, i) => CustomTimeLinesWidget(
                isFirst: i == 0,
                isLast: i == controller.repayment.length - 1,
                tracking: controller.repayment[i],
                controller: controller,
              ),
        ),
      );
    });
  }
}

// BM/CEO list
class _BmList extends StatelessWidget {
  const _BmList({required this.controller});
  final PaymentListController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tab = controller.selectedTab.value;

      if (tab == 'paylist') {
        if (controller.isLoading.value) {
          return const Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (controller.repayment.isEmpty) {
          return Expanded(
            child: NoDataWidget(text: LocaleKeys.searchNotFound.tr),
          );
        }

        return Expanded(
          child: AbsorbPointer(
            child: ListView.builder(
              padding: UIConstants.spacing.padHorizontal,
              itemCount: controller.repayment.length,
              itemBuilder:
                  (ctx, i) => CustomTimeLinesWidget(
                    isFirst: i == 0,
                    isLast: i == controller.repayment.length - 1,
                    tracking: controller.repayment[i],
                    controller: controller,
                  ),
            ),
          ),
        );
      }

      if (controller.isRepaymentLoading.value) {
        return const Expanded(
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.bmRepaymentList.isEmpty) {
        return Expanded(
          child: NoDataWidget(text: LocaleKeys.searchNotFound.tr),
        );
      }

      return Expanded(
        child: AbsorbPointer(
          child: ListView.builder(
            padding: UIConstants.spacing.padHorizontal,
            itemCount: controller.bmRepaymentList.length,
            itemBuilder:
                (ctx, i) => Padding(
                  padding: UIConstants.spacing.padBottom,
                  child: RepaymentItemWidget(
                    delivery: controller.bmRepaymentList[i],
                  ),
                ),
          ),
        ),
      );
    });
  }
}
