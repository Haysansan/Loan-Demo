import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/views/views.dart';
import 'package:apploan/models/models.dart';

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
      appBar: CustomAppBar(
        title: LocaleKeys.loanDisbursmentsList.tr,
        onBack: () {
          final startCtl = Get.find<StartController>();
          startCtl.changeMenu(startCtl.previousIndex.value);
        },
      ),
      body: controller.isBmOrCeo ? _buildBmCeoBody() : _buildCoBody(),
    );
  }

  // CO layout
  Widget _buildCoBody() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Totals
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  top: 5.0,
                  right: 10.0,
                  bottom: 5.0,
                ),
                child: TotalDisburmentWidget(
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
                child: TotalDisburmentAmountWidget(
                  codKhr: '${controller.totalAmount.text}',
                ),
              ),
            ],
          ),

          10.height,

          // Search bar
          _buildSearchBar(),

          // List
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (controller.isDone && controller.disburment.isEmpty) {
              return NoDataWidget(text: LocaleKeys.searchNotFound.tr);
            } else {
              return Expanded(child: _buildList());
            }
          }),
        ],
      );
    });
  }

  // BM / CEO layout
  Widget _buildBmCeoBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Branch selector ──
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
          child: Obx(() {
            if (controller.isBranchLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppColor.red),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ជ្រើសរើសសាខា', style: AppTextStyle.normalPrimaryRegular),
                4.height,
                DropdownButtonFormField<IdNameModel>(
                  value: controller.selectedBranch.value,
                  hint: Text(
                    '-- ជ្រើសរើសសាខា --',
                    style: AppTextStyle.normalLightGreyRegular,
                  ),
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.white,
                    contentPadding: 15.padHorizontal,
                    border: OutlineInputBorder(
                      borderRadius: UIConstants.radius.radiusAll,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: UIConstants.radius.radiusAll,
                      borderSide: const BorderSide(
                        color: AppColor.lightGrey,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: UIConstants.radius.radiusAll,
                      borderSide: const BorderSide(color: AppColor.lightGrey),
                    ),
                  ),
                  dropdownColor: AppColor.white,
                  items:
                      controller.branchList
                          .map(
                            (branch) => DropdownMenuItem<IdNameModel>(
                              value: branch,
                              child: Text(
                                branch.name,
                                style: AppTextStyle.normalPrimaryRegular,
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: controller.onBranchChanged,
                ),
              ],
            );
          }),
        ),

        10.height,

        // ── Totals – visible only after a branch is chosen ──
        // Obx(() {
        //   if (controller.selectedBranch.value == null) {
        //     return const SizedBox.shrink();
        //   }
        //   return Column(
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.only(
        //           left: 10.0,
        //           top: 5.0,
        //           right: 10.0,
        //           bottom: 5.0,
        //         ),
        //         child: TotalDisburmentWidget(
        //           icon: Icons.people_alt,
        //           packages:
        //               '${controller.totalClient.text}'
        //               ' ${LocaleKeys.clients.tr}',
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(
        //           left: 10.0,
        //           top: 0.0,
        //           right: 10.0,
        //           bottom: 0.0,
        //         ),
        //         child: TotalDisburmentAmountWidget(
        //           codKhr: '${controller.totalAmount.text}',
        //         ),
        //       ),
        //     ],
        //   );
        // }),
        10.height,

        // ── Search bar ──
        _buildSearchBar(),
        20.height,
        // ── List ──
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.red),
            );
          }
          if (controller.selectedBranch.value == null) {
            return Center(
              child: Padding(
                padding: 24.padAll,
                child: Text(
                  'សូមជ្រើសសាខាដើម្បីមើលបញ្ជីបញ្ចេញប្រាក់',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.normalGreyRegular,
                ),
              ),
            );
          }
          if (controller.isDone && controller.disburment.isEmpty) {
            return NoDataWidget(text: LocaleKeys.searchNotFound.tr);
          }
          return Expanded(child: _buildList());
        }),
      ],
    );
  }

  // Shared widgets

  Widget _buildSearchBar() {
    return Padding(
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
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: controller.disburment.length,
      itemBuilder: (context, index) {
        return EndsChildWidget(tracking: controller.disburment[index]);
      },
    );
  }
}
