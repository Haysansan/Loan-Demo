import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';
import 'package:apploan/views/views.dart';
import 'shared_coborrower_guarantor.dart';

class CoBorrowerFormSheet extends GetView<CoBorrowerController> {
  const CoBorrowerFormSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 28),
          onPressed: Get.back,
        ),
        centerTitle: true,
        title: const Text(
          'Add Co-Borrowers',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.grey),
            onPressed: Get.back,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BorrowerFieldLabel('Full Name', required: true),
              _buildTextField(controller.fullNameController, 'Full name'),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const BorrowerFieldLabel('Date of birth'),
                        BorrowerDatePickerField(obs: controller.selectedDate),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const BorrowerFieldLabel('Gender'),
                        BorrowerGenderDropdown(
                          selected: controller.selectedGender,
                          options: controller.genderOptions,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const BorrowerFieldLabel('Phone number', required: true),
              _buildTextField(
                controller.phoneController,
                'Phone number',
                keyboard: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              const BorrowerFieldLabel('Type of ID', required: true),
              Obx(
                () => BorrowerIdTypeDropdown<CoBorrowerIdTypeModel>(
                  selected: controller.selectedIdType,
                  items: controller.idTypes,
                ),
              ),
              const SizedBox(height: 20),
              const BorrowerFieldLabel('National ID', required: true),
              _buildTextField(
                controller.nationalIdController,
                'Numbers..',
                keyboard: TextInputType.number,
              ),
              const SizedBox(height: 32),
              BorrowerSubmitButton(onPressed: controller.submit),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String hint, {
    TextInputType? keyboard,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      validator:
          (v) =>
              (v == null || v.trim().isEmpty) ? 'This field is required' : null,
      decoration: borrowerInputDecoration(hint),
    );
  }
}
