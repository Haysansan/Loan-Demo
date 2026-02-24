import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/views/views.dart';
import 'package:intl/intl.dart';

class DisburmentListView extends GetView<DisburmentListController> {
  const DisburmentListView({Key? key}) : super(key: key);

  void onSearch() async {
    if (controller.formKey.currentState?.validate() ?? false) {
      await controller.fetchDisburmentList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top:5.0, right: 10.0, bottom: 5.0),
                  child:
                    TotalDisburmentWidget(
                        icon: Icons.people_alt,
                        packages: '${controller.totalClient.text }' ' ${LocaleKeys
                            .clients.tr}'),
                    ),
                    Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
                    child:
                      TotalDisburmentAmountWidget(
                        codKhr: '${controller.totalAmount.text }'
                      ),
                    ),
                  ]),
            10.height,
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

            Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else if (controller.isDone && controller.disburment.isEmpty) {
                return NoDataWidget(text: LocaleKeys.searchNotFound.tr);
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: controller.disburment.length,
                    itemBuilder: (context, index) {
                      return EndsChildWidget(
                        tracking: controller.disburment[index],
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