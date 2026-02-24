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
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  top: 5.0,
                  right: 10.0,
                  bottom: 5.0,
                ),
                child: TotalPackageWidget(
                  icon: Icons.people_alt,
                  packages:
                      '${controller.totalClient.text}'
                      ' ${LocaleKeys.clients.tr}',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  top: 0.0,
                  right: 10.0,
                  bottom: 0.0,
                ),
                child: TotalIncomeWidget(codKhr: controller.totalAmount.text),
              ),
              UIConstants.spacing.height,
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
                          validator: (text) => FormValidator.empty(text),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    PrimaryButton(
                      text: LocaleKeys.search.tr.toUpperCase(),
                      width: 100,
                      onPressed: onSearch,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (controller.isDone && controller.repayment.isEmpty) {
                  return NoDataWidget(text: LocaleKeys.searchNotFound.tr);
                } else {
                  return Expanded(
                    child: ListView.builder(
                      padding: UIConstants.spacing.padHorizontal,
                      itemCount: controller.repayment.length,
                      itemBuilder: (context, index) {
                        return CustomTimeLinesWidget(
                          isFirst: index == 0,
                          isLast: index == controller.repayment.length - 1,
                          tracking: controller.repayment[index],
                          controller: controller,
                        );
                      },
                    ),
                  );
                }
              }),
            ],
          );
        }
      }),
    );
  }
}
