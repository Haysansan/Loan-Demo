import 'package:apploan/models/disbursement/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';
import 'package:apploan/views/views.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisburmentListController extends GetxController {
  final TextEditingController searchCtl = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxList<DisbursementListModel> disburment = <DisbursementListModel>[].obs;
  final RxBool isLoading = false.obs;
  final TextEditingController totalClient = TextEditingController();
  final TextEditingController totalAmount = TextEditingController();

  bool isDone = false;
  final StartController startCtl = Get.find<StartController>();

  @override
  void onInit() {
    fetchDisburmentList();
    super.onInit();
  }



  @override
  void onClose() {
    searchCtl.dispose();
    super.onClose();
  }
  String formatCurrency(String amount) {
    // ignore: unnecessary_null_comparison
    return amount != null
        ? '${NumberFormat.currency(locale: 'en_US', symbol: '').format(double.parse(amount))}'.replaceAll('.00', ' រៀល')
        : 'N/A';
  }
// show branch_id for login
  Future<int?> getbranchId() async {
    int? branchId = await SharedPreferencesManager.getIntValue('branch_id');
    return branchId;
  }
  // show user_id from login
  Future<int?> getUserId() async {
    int? user_id = await SharedPreferencesManager.getIntValue('user_id');
    return user_id;
  }
  Future<void> fetchDisburmentList() async {
    try {
      int? user_id = await getUserId();
      isLoading.value = true;
      final Map<String, dynamic> param = {'user_id':user_id};
      final res = await Get.find<ApiService>().get(
        EndPoints.disbursement,
        queryParameters: param,
        isShowLoading: true,
      );
      final data = getPropertyFromJson(res.data, 'data');
      disburment.value = List.from(
        (data as List).map((e) => DisbursementListModel.fromJson(e)).toList(),
      );
      totalClient.text  = getPropertyFromJson(res.data, 'totalClient');
      totalAmount.text  = formatCurrency(getPropertyFromJson(res.data, 'totalDisbursement'));
      isDone = true;
      DialogManager.hideLoading();
    } catch (e) {
      ExceptionHandler.handleException(e);
    }
    finally {
      isLoading.value = false;
    }
  }
}
