import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';

class GuarantorController extends GetxController {
  final _api = Get.find<ApiService>();

  final formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final nationalIdController = TextEditingController();
  final relationshipController = TextEditingController();

  final selectedGender = RxnString();
  final selectedIdType = Rxn<GuarantorIdTypeModel>();
  final selectedDate = Rxn<DateTime>();

  final idTypes = <GuarantorIdTypeModel>[].obs;
  final added = <GuarantorModel>[].obs;

  final genderOptions = ['Female', 'Male'];

  @override
  void onInit() {
    super.onInit();
    _fetchIdTypes();
  }

  Future<void> _fetchIdTypes() async {
    try {
      final res = await _api.get('/api/id-types');
      final list =
          (res.data['data'] as List)
              .map(
                (e) => GuarantorIdTypeModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
      idTypes.assignAll(list);
    } catch (_) {}
  }

  void submit() {
    if (!formKey.currentState!.validate()) return;

    final guarantor = GuarantorModel(
      fullname: fullNameController.text.trim(),
      dateOfBirth:
          selectedDate.value != null
              ? DateFormat('yyyy-MM-dd').format(selectedDate.value!)
              : null,
      gender: selectedGender.value,
      phoneNumber: phoneController.text.trim(),
      idTypeId: selectedIdType.value!.id,
      nationalId: nationalIdController.text.trim(),
      relationship: relationshipController.text.trim(),
    );

    added.add(guarantor);
    _resetForm();
    Get.back();
  }

  void remove(int index) => added.removeAt(index);

  void _resetForm() {
    fullNameController.clear();
    phoneController.clear();
    nationalIdController.clear();
    relationshipController.clear();
    selectedGender.value = null;
    selectedIdType.value = null;
    selectedDate.value = null;
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    nationalIdController.dispose();
    relationshipController.dispose();
    super.onClose();
  }
}
