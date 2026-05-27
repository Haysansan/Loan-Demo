import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';
import 'package:apploan/routes.dart';
import 'package:apploan/views/views.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCustomersView extends GetView<AddCustomersController> {
  const AddCustomersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        title: Text(
          LocaleKeys.addCustomer.tr,
          style: AppTextStyle.normalWhiteRegular,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        backgroundColor: AppColor.primary,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.red),
          );
        } else {
          // Add your main content here when loading is complete
          return Padding(
            padding: UIConstants.spacing.padHorizontal,
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    UIConstants.spacing.height,
                    // Total amount
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "First name",
                                    style: AppTextStyle.normalPrimaryRegular,
                                  ),
                                  2.height,
                                  CustomTextField(
                                    controller: controller.firstName,
                                    hintText: 'First name',
                                    textInputAction: TextInputAction.next,
                                    validator:
                                        (text) => FormValidator.empty(text),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Last name",
                                    style: AppTextStyle.normalPrimaryRegular,
                                  ),
                                  2.height,
                                  CustomTextField(
                                    controller: controller.lastName,
                                    hintText: 'Last name',
                                    textInputAction: TextInputAction.next,
                                    validator:
                                        (text) => FormValidator.empty(text),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    UIConstants.spacing.height,
                    // Total amount
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Gender",
                                    style: AppTextStyle.normalPrimaryRegular,
                                  ),
                                  DropdownSearch<String>(
                                    items: controller.genderItems,
                                    onChanged:
                                        (value) => controller.selectGender(
                                          value ?? '',
                                        ),
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.all(8),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                        ),
                                    popupProps: PopupProps.menu(
                                      showSearchBox: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Date Of Birth",
                                    style: AppTextStyle.normalPrimaryRegular,
                                  ),
                                  2.height,
                                  InkWell(
                                    onTap:
                                        () => controller.getDatePicker().show(),
                                    child: StackTextField(
                                      controller: controller.dateOfBirth,
                                      hintText: LocaleKeys.chooseDate.tr,
                                      validator:
                                          (text) =>
                                              FormValidator.phoneNumber(text),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    UIConstants.spacing.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Phone number",
                                    style: AppTextStyle.normalPrimaryRegular,
                                  ),
                                  2.height,
                                  CustomTextField(
                                    controller: controller.phoneNumber,
                                    hintText: 'Phone number',
                                    textInputAction: TextInputAction.next,
                                    validator:
                                        (text) => FormValidator.empty(text),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "GIS code",
                                    style: AppTextStyle.normalPrimaryRegular,
                                  ),
                                  2.height,
                                  CustomTextField(
                                    controller: controller.gisCode,
                                    hintText: 'GIS code',
                                    textInputAction: TextInputAction.next,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    UIConstants.spacing.height,
                    // Total amount
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(() {
                                    if (controller.isLoading.value) {
                                      // Display loading indicator when data is being fetched
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColor.red,
                                        ),
                                      );
                                    }
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Province",
                                          style:
                                              AppTextStyle.normalPrimaryRegular,
                                        ),
                                        SearchDropDown<ProvinceModel>(
                                          items: controller.ProvinceList,
                                          itemAsString:
                                              (item) =>
                                                  '${item.id} - ${item.name}', // Convert StaffModel to String
                                          onChanged: (value) {
                                            controller.onProvinceChanged(
                                              value as ProvinceModel?,
                                            );
                                            controller.fetchDistrict(
                                              controller.ProvinceSelected?.id,
                                            );
                                          },
                                          selectedItem:
                                              controller.ProvinceSelected,
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(() {
                                    if (controller.isLoading_district.value) {
                                      // Display loading indicator when data is being fetched
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColor.red,
                                        ),
                                      );
                                    }
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "District",
                                          style:
                                              AppTextStyle.normalPrimaryRegular,
                                        ),
                                        SearchDropDown<DistrictModel>(
                                          items: controller.districtList,
                                          itemAsString:
                                              (item) =>
                                                  '${item.id} - ${item.name}', // Convert StaffModel to String
                                          onChanged: (value) {
                                            controller.onDistrictChanged(
                                              value as DistrictModel?,
                                            );
                                            controller.fetchCommune(
                                              controller.DistrictSelected?.id,
                                            );
                                          },
                                          selectedItem:
                                              controller.DistrictSelected,
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    UIConstants.spacing.height,
                    // Total amount
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(() {
                                    if (controller.isLoading_commune.value) {
                                      // Display loading indicator when data is being fetched
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColor.red,
                                        ),
                                      );
                                    }
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Commune",
                                          style:
                                              AppTextStyle.normalPrimaryRegular,
                                        ),
                                        SearchDropDown<CommuneModel>(
                                          items: controller.CommuneList,
                                          itemAsString:
                                              (item) =>
                                                  '${item.id} - ${item.name}', // Convert StaffModel to String
                                          onChanged: (value) {
                                            controller.onCommuneChanged(
                                              value as CommuneModel?,
                                            );
                                            controller.fetchVillage(
                                              controller.CommuneSelected?.id,
                                            );
                                          },
                                          selectedItem:
                                              controller.CommuneSelected,
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(() {
                                    if (controller.isLoading_village.value) {
                                      // Display loading indicator when data is being fetched
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColor.red,
                                        ),
                                      );
                                    }
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Village",
                                          style:
                                              AppTextStyle.normalPrimaryRegular,
                                        ),
                                        SearchDropDown<VillageModel>(
                                          items: controller.VillageList,
                                          itemAsString:
                                              (item) =>
                                                  '${item.id} - ${item.name}', // Convert StaffModel to String
                                          onChanged: (value) {
                                            controller.onVillageChanged(
                                              value as VillageModel?,
                                            );
                                          },
                                          selectedItem:
                                              controller.VillageSelected,
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Submit
                    UIConstants.spacing.height,
                    PrimaryButton(
                      text: LocaleKeys.submit.tr,
                      onPressed: () async {
                        if (!controller.formKey.currentState!.validate()) {
                          return;
                        }
                        controller.formKey.currentState!.save();
                        await controller.submitBooking();
                      },
                    ),

                    30.height,
                  ],
                ),
              ),
            ),
          );
        }
      }),
    );
  }

  void AddCustomerHandleTap() {
    Get.back();
    Get.toNamed(Routes.addCustomer);
  }
}
