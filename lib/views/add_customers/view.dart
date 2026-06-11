// import 'package:apploan/core/core.dart';
// import 'package:apploan/models/models.dart';
// import 'package:apploan/views/views.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:io';

// class AddCustomersView extends GetView<AddCustomersController> {
//   const AddCustomersView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: LocaleKeys.addCustomer.tr,
//         onBack: () => Navigator.pop(context, false),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(
//             child: CircularProgressIndicator(color: AppColor.red),
//           );
//         }
//         return Padding(
//           padding: UIConstants.spacing.padHorizontal,
//           child: SingleChildScrollView(
//             child: Form(
//               key: controller.formKey,
//               child: Column(
//                 children: [
//                   UIConstants.spacing.height,
//                   // Profile photo
//                   Center(
//                     child: Obx(() {
//                       return GestureDetector(
//                         onTap: controller.pickProfileImage,
//                         child: Stack(
//                           children: [
//                             CircleAvatar(
//                               radius: 50,
//                               backgroundColor: AppColor.lightGrey,
//                               backgroundImage:
//                                   controller.profileImage.value != null
//                                       ? FileImage(
//                                         File(
//                                           controller.profileImage.value!.path,
//                                         ),
//                                       )
//                                       : null,
//                               child:
//                                   controller.profileImage.value == null
//                                       ? const Icon(
//                                         Icons.person,
//                                         size: 50,
//                                         color: AppColor.grey,
//                                       )
//                                       : null,
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               right: 0,
//                               child: Container(
//                                 padding: const EdgeInsets.all(6),
//                                 decoration: const BoxDecoration(
//                                   color: AppColor.primary,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: const Icon(
//                                   Icons.camera_alt,
//                                   size: 16,
//                                   color: AppColor.white,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }),
//                   ),
//                   UIConstants.spacing.height,
//                   // First name / Last name
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'First name',
//                               style: AppTextStyle.normalPrimaryRegular,
//                             ),
//                             2.height,
//                             CustomTextField(
//                               controller: controller.firstName,
//                               hintText: 'First name',
//                               textInputAction: TextInputAction.next,
//                               validator: (text) => FormValidator.empty(text),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Last name',
//                               style: AppTextStyle.normalPrimaryRegular,
//                             ),
//                             2.height,
//                             CustomTextField(
//                               controller: controller.lastName,
//                               hintText: 'Last name',
//                               textInputAction: TextInputAction.next,
//                               validator: (text) => FormValidator.empty(text),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   UIConstants.spacing.height,
//                   // Gender / Date of birth
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Gender',
//                               style: AppTextStyle.normalPrimaryRegular,
//                             ),
//                             DropdownSearch<String>(
//                               items: controller.genderItems,
//                               onChanged:
//                                   (value) =>
//                                       controller.selectGender(value ?? ''),
//                               dropdownDecoratorProps: DropDownDecoratorProps(
//                                 dropdownSearchDecoration: InputDecoration(
//                                   contentPadding: const EdgeInsets.all(8),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                               ),
//                               popupProps: PopupProps.menu(showSearchBox: false),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Date Of Birth',
//                               style: AppTextStyle.normalPrimaryRegular,
//                             ),
//                             2.height,
//                             InkWell(
//                               onTap: () => controller.getDatePicker().show(),
//                               child: StackTextField(
//                                 controller: controller.dateOfBirth,
//                                 hintText: LocaleKeys.chooseDate.tr,
//                                 validator:
//                                     (text) => FormValidator.phoneNumber(text),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   UIConstants.spacing.height,
//                   // Phone / GIS code
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Phone number',
//                               style: AppTextStyle.normalPrimaryRegular,
//                             ),
//                             2.height,
//                             CustomTextField(
//                               controller: controller.phoneNumber,
//                               hintText: 'Phone number',
//                               textInputAction: TextInputAction.next,
//                               validator: (text) => FormValidator.empty(text),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'GIS code',
//                               style: AppTextStyle.normalPrimaryRegular,
//                             ),
//                             2.height,
//                             CustomTextField(
//                               controller: controller.gisCode,
//                               hintText: 'GIS code',
//                               textInputAction: TextInputAction.next,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   UIConstants.spacing.height,
//                   // Province / District
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Obx(() {
//                           if (controller.isLoading.value) {
//                             return const Center(
//                               child: CircularProgressIndicator(
//                                 color: AppColor.red,
//                               ),
//                             );
//                           }
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Province',
//                                 style: AppTextStyle.normalPrimaryRegular,
//                               ),
//                               SearchDropDown<ProvinceModel>(
//                                 items: controller.provinceList,
//                                 itemAsString:
//                                     (item) => '${item.id} - ${item.name}',
//                                 onChanged: (value) {
//                                   controller.provinceSelected =
//                                       value as ProvinceModel?;
//                                   controller.fetchDistrict(
//                                     controller.provinceSelected?.id,
//                                   );
//                                 },
//                                 selectedItem: controller.provinceSelected,
//                               ),
//                             ],
//                           );
//                         }),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Obx(() {
//                           if (controller.isLoadingDistrict.value) {
//                             return const Center(
//                               child: CircularProgressIndicator(
//                                 color: AppColor.red,
//                               ),
//                             );
//                           }
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'District',
//                                 style: AppTextStyle.normalPrimaryRegular,
//                               ),
//                               SearchDropDown<DistrictModel>(
//                                 items: controller.districtList,
//                                 itemAsString:
//                                     (item) => '${item.id} - ${item.name_kh}',
//                                 onChanged: (value) {
//                                   controller.districtSelected =
//                                       value as DistrictModel?;
//                                   controller.fetchCommune(
//                                     controller.districtSelected?.id,
//                                   );
//                                 },
//                                 selectedItem: controller.districtSelected,
//                               ),
//                             ],
//                           );
//                         }),
//                       ),
//                     ],
//                   ),
//                   UIConstants.spacing.height,
//                   // Commune / Village
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Obx(() {
//                           if (controller.isLoadingCommune.value) {
//                             return const Center(
//                               child: CircularProgressIndicator(
//                                 color: AppColor.red,
//                               ),
//                             );
//                           }
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Commune',
//                                 style: AppTextStyle.normalPrimaryRegular,
//                               ),
//                               SearchDropDown<CommuneModel>(
//                                 items: controller.communeList,
//                                 itemAsString:
//                                     (item) => '${item.id} - ${item.name}',
//                                 onChanged: (value) {
//                                   controller.communeSelected =
//                                       value as CommuneModel?;
//                                   controller.fetchVillage(
//                                     controller.communeSelected?.id,
//                                   );
//                                 },
//                                 selectedItem: controller.communeSelected,
//                               ),
//                             ],
//                           );
//                         }),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Obx(() {
//                           if (controller.isLoadingVillage.value) {
//                             return const Center(
//                               child: CircularProgressIndicator(
//                                 color: AppColor.red,
//                               ),
//                             );
//                           }
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Village',
//                                 style: AppTextStyle.normalPrimaryRegular,
//                               ),
//                               SearchDropDown<VillageModel>(
//                                 items: controller.villageList,
//                                 itemAsString:
//                                     (item) => '${item.id} - ${item.name}',
//                                 onChanged: (value) {
//                                   controller.villageSelected =
//                                       value as VillageModel?;
//                                 },
//                                 selectedItem: controller.villageSelected,
//                               ),
//                             ],
//                           );
//                         }),
//                       ),
//                     ],
//                   ),
//                   UIConstants.spacing.height,
//                   // Co-Borrowers
//                   _PeopleSection(
//                     label: 'Co-Borrowers',
//                     required: true,
//                     addLabel: '+ Add Co-Borrowers',
//                     emptyText: 'No Co-Borrowers Selected',
//                     tag: AddCustomersController.coBorrowerTag,
//                     onAdd:
//                         () => Get.to(
//                           () => CoBorrowerFormSheet(
//                             tag: AddCustomersController.coBorrowerTag,
//                           ),
//                         ),
//                   ),
//                   UIConstants.spacing.height,
//                   // Guarantors
//                   _PeopleSection(
//                     label: 'Guarantors',
//                     required: true,
//                     addLabel: '+ Add Guarantors',
//                     emptyText: 'No Guarantors Selected',
//                     tag: AddCustomersController.guarantorTag,
//                     onAdd:
//                         () => Get.to(
//                           () => CoBorrowerFormSheet(
//                             tag: AddCustomersController.guarantorTag,
//                           ),
//                         ),
//                   ),
//                   UIConstants.spacing.height,
//                   // Submit
//                   PrimaryButton(
//                     text: LocaleKeys.submit.tr,
//                     onPressed: () async {
//                       if (!controller.formKey.currentState!.validate()) return;
//                       controller.formKey.currentState!.save();
//                       await controller.submitBooking();
//                     },
//                   ),
//                   30.height,
//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }

// // ── Private widgets ────────────────────────────────────────────────────────────

// class _PeopleSection extends StatelessWidget {
//   const _PeopleSection({
//     required this.label,
//     required this.addLabel,
//     required this.emptyText,
//     required this.tag,
//     required this.onAdd,
//     this.required = false,
//   });

//   final String label;
//   final String addLabel;
//   final String emptyText;
//   final String tag;
//   final VoidCallback onAdd;
//   final bool required;

//   CoBorrowerController get ctrl => Get.find<CoBorrowerController>(tag: tag);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             RichText(
//               text: TextSpan(
//                 text: label,
//                 style: AppTextStyle.normalPrimaryRegular,
//                 children:
//                     required
//                         ? const [
//                           TextSpan(
//                             text: ' *',
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         ]
//                         : [],
//               ),
//             ),
//             GestureDetector(
//               onTap: onAdd,
//               child: Text(
//                 addLabel,
//                 style: const TextStyle(
//                   color: AppColor.red,
//                   fontWeight: FontWeight.w500,
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Container(
//           width: double.infinity,
//           constraints: const BoxConstraints(minHeight: 50),
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey.shade300),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Obx(() {
//             if (ctrl.addedCoBorrower.isEmpty) {
//               return Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     emptyText,
//                     style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
//                   ),
//                   Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
//                 ],
//               );
//             }
//             return CoBorrowerTagList(tag: tag);
//           }),
//         ),
//       ],
//     );
//   }
// }

import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';
import 'package:apploan/views/add_customers/guarantor_controller.dart';
import 'package:apploan/core/widgets/bottom_sheet/coborrower.dart';
import 'package:apploan/core/widgets/bottom_sheet/guarantor.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:apploan/views/views.dart';

class AddCustomersView extends GetView<AddCustomersController> {
  const AddCustomersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coBorrowerCtrl = Get.find<CoBorrowerController>();
    final guarantorCtrl = Get.find<GuarantorController>();

    return Scaffold(
      appBar: CustomAppBar(
        title: LocaleKeys.addCustomer.tr,
        onBack: () => Navigator.pop(context, false),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.red),
          );
        }
        return Padding(
          padding: UIConstants.spacing.padHorizontal,
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  UIConstants.spacing.height,
                  // Profile photo
                  Center(
                    child: Obx(() {
                      return GestureDetector(
                        onTap: controller.pickProfileImage,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: AppColor.lightGrey,
                              backgroundImage:
                                  controller.profileImage.value != null
                                      ? FileImage(
                                        File(
                                          controller.profileImage.value!.path,
                                        ),
                                      )
                                      : null,
                              child:
                                  controller.profileImage.value == null
                                      ? const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: AppColor.grey,
                                      )
                                      : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppColor.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: AppColor.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  UIConstants.spacing.height,
                  // First name / Last name
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'First name',
                              style: AppTextStyle.normalPrimaryRegular,
                            ),
                            2.height,
                            CustomTextField(
                              controller: controller.firstName,
                              hintText: 'First name',
                              textInputAction: TextInputAction.next,
                              validator: (text) => FormValidator.empty(text),
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
                              'Last name',
                              style: AppTextStyle.normalPrimaryRegular,
                            ),
                            2.height,
                            CustomTextField(
                              controller: controller.lastName,
                              hintText: 'Last name',
                              textInputAction: TextInputAction.next,
                              validator: (text) => FormValidator.empty(text),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  UIConstants.spacing.height,
                  // Gender / Date of birth
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gender',
                              style: AppTextStyle.normalPrimaryRegular,
                            ),
                            DropdownSearch<String>(
                              items: controller.genderItems,
                              onChanged:
                                  (value) =>
                                      controller.selectGender(value ?? ''),
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              popupProps: PopupProps.menu(showSearchBox: false),
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
                              'Date Of Birth',
                              style: AppTextStyle.normalPrimaryRegular,
                            ),
                            2.height,
                            InkWell(
                              onTap: () => controller.getDatePicker().show(),
                              child: StackTextField(
                                controller: controller.dateOfBirth,
                                hintText: LocaleKeys.chooseDate.tr,
                                validator:
                                    (text) => FormValidator.phoneNumber(text),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  UIConstants.spacing.height,
                  // Phone / GIS code
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Phone number',
                              style: AppTextStyle.normalPrimaryRegular,
                            ),
                            2.height,
                            CustomTextField(
                              controller: controller.phoneNumber,
                              hintText: 'Phone number',
                              textInputAction: TextInputAction.next,
                              validator: (text) => FormValidator.empty(text),
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
                              'GIS code',
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
                  UIConstants.spacing.height,
                  // Province / District
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColor.red,
                              ),
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Province',
                                style: AppTextStyle.normalPrimaryRegular,
                              ),
                              SearchDropDown<ProvinceModel>(
                                items: controller.ProvinceList,
                                itemAsString:
                                    (item) => '${item.id} - ${item.name}',
                                onChanged: (value) {
                                  controller.ProvinceSelected = value;
                                  controller.fetchDistrict(value?.id);
                                },
                                selectedItem: controller.ProvinceSelected,
                              ),
                            ],
                          );
                        }),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Obx(() {
                          if (controller.isLoading_district.value) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColor.red,
                              ),
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'District',
                                style: AppTextStyle.normalPrimaryRegular,
                              ),
                              SearchDropDown<DistrictModel>(
                                items: controller.districtList,
                                itemAsString:
                                    (item) => '${item.id} - ${item.name_kh}',
                                onChanged: (value) {
                                  controller.DistrictSelected = value;
                                  controller.fetchCommune(value?.id);
                                },
                                selectedItem: controller.DistrictSelected,
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                  UIConstants.spacing.height,
                  // Commune / Village
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() {
                          if (controller.isLoading_commune.value) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColor.red,
                              ),
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Commune',
                                style: AppTextStyle.normalPrimaryRegular,
                              ),
                              SearchDropDown<CommuneModel>(
                                items: controller.CommuneList,
                                itemAsString:
                                    (item) => '${item.id} - ${item.name}',
                                onChanged: (value) {
                                  controller.CommuneSelected = value;
                                  controller.fetchVillage(value?.id);
                                },
                                selectedItem: controller.CommuneSelected,
                              ),
                            ],
                          );
                        }),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Obx(() {
                          if (controller.isLoading_village.value) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColor.red,
                              ),
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Village',
                                style: AppTextStyle.normalPrimaryRegular,
                              ),
                              SearchDropDown<VillageModel>(
                                items: controller.VillageList,
                                itemAsString:
                                    (item) => '${item.id} - ${item.name}',
                                onChanged:
                                    (value) =>
                                        controller.VillageSelected = value,
                                selectedItem: controller.VillageSelected,
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                  UIConstants.spacing.height,
                  // Co-Borrowers
                  _PeopleSection(
                    label: 'Co-Borrowers',
                    required: true,
                    addLabel: '+ Add Co-Borrowers',
                    emptyText: 'No Co-Borrowers Selected',
                    added: coBorrowerCtrl.added,
                    getName: (e) => (e as CoBorrowerModel).fullname,
                    onRemove: coBorrowerCtrl.remove,
                    onAdd:
                        () => Get.bottomSheet(
                          FractionallySizedBox(
                            heightFactor: 0.87,
                            child: const CoBorrowerFormSheet(),
                          ),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                        ),
                  ),
                  UIConstants.spacing.height,
                  // Guarantors
                  _PeopleSection(
                    label: 'Guarantors',
                    required: true,
                    addLabel: '+ Add Guarantors',
                    emptyText: 'No Guarantors Selected',
                    added: guarantorCtrl.added,
                    getName: (e) => (e as GuarantorModel).fullname,
                    onRemove: guarantorCtrl.remove,
                    onAdd:
                        () => Get.bottomSheet(
                          FractionallySizedBox(
                            heightFactor: 0.87,
                            child: const GuarantorFormSheet(),
                          ),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                        ),
                  ),
                  UIConstants.spacing.height,
                  // Submit
                  PrimaryButton(
                    text: LocaleKeys.submit.tr,
                    onPressed: () async {
                      if (!controller.formKey.currentState!.validate()) return;
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
      }),
    );
  }
}

// ── Private widget ───

class _PeopleSection extends StatelessWidget {
  const _PeopleSection({
    required this.label,
    required this.addLabel,
    required this.emptyText,
    required this.added,
    required this.getName,
    required this.onRemove,
    required this.onAdd,
    this.required = false,
  });

  final String label;
  final String addLabel;
  final String emptyText;
  final RxList added;
  final String Function(dynamic) getName;
  final void Function(int) onRemove;
  final VoidCallback onAdd;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text: label,
                style: AppTextStyle.normalPrimaryRegular,
                children:
                    required
                        ? const [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ]
                        : [],
              ),
            ),
            GestureDetector(
              onTap: onAdd,
              child: Text(
                addLabel,
                style: const TextStyle(
                  color: AppColor.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 50),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Obx(() {
            if (added.isEmpty) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    emptyText,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                ],
              );
            }
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  added.asMap().entries.map((entry) {
                    return Chip(
                      label: Text(
                        getName(entry.value),
                        style: AppTextStyle.smallGreyRegular,
                      ),
                      deleteIcon: const Icon(Icons.close, size: 14),
                      onDeleted: () => onRemove(entry.key),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: AppColor.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }).toList(),
            );
          }),
        ),
      ],
    );
  }
}
