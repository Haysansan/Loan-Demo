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
  final RxList<DisbursementListModel> disburment =
      <DisbursementListModel>[].obs;
  final RxBool isLoading = false.obs;
  final TextEditingController totalClient = TextEditingController();
  final TextEditingController totalAmount = TextEditingController();

  // ── BM / CEO only ──
  final RxBool isBranchLoading = false.obs;
  final RxList<IdNameModel> branchList = <IdNameModel>[].obs;
  final Rxn<IdNameModel> selectedBranch = Rxn<IdNameModel>();

  bool isDone = false;
  final StartController startCtl = Get.find<StartController>();

  /// True when the logged-in user is Branch Manager or CEO.
  bool get isBmOrCeo =>
      UserRepository.shared.isBM || UserRepository.shared.isEco;

  // ─────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void onInit() {
    if (isBmOrCeo) {
      fetchBranches(); // load branch dropdown; list fetch is triggered on selection
    } else {
      fetchDisburmentList(); // CO: fetch immediately as before
    }
    super.onInit();
  }

  @override
  void onClose() {
    searchCtl.dispose();
    totalClient.dispose();
    totalAmount.dispose();
    super.onClose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────

  String formatCurrency(String amount) {
    // ignore: unnecessary_null_comparison
    return amount != null
        ? '${NumberFormat.currency(locale: 'en_US', symbol: '').format(double.parse(amount))}'
            .replaceAll('.00', ' រៀល')
        : 'N/A';
  }

  // show branch_id stored at login (CO)
  Future<int?> getbranchId() async {
    int? branchId = await SharedPreferencesManager.getIntValue('branch_id');
    return branchId;
  }

  // show user_id stored at login (CO)
  Future<int?> getUserId() async {
    int? user_id = await SharedPreferencesManager.getIntValue('user_id');
    return user_id;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BM / CEO – branch dropdown
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> fetchBranches() async {
    try {
      isBranchLoading.value = true;
      final res = await Get.find<ApiService>().get(
        EndPoints
            .getBranches, // add `static String get getBranches => 'get_branches';` to EndPoints
        isShowLoading: false,
      );
      final data = getPropertyFromJson(res.data, 'data');
      branchList.value = List<IdNameModel>.from(
        (data as List).map(
          (e) => IdNameModel(id: e['id'] ?? 0, name: e['name'] ?? 'N/A'),
        ),
      );
    } catch (e) {
      if (isClosed) return;
      ExceptionHandler.handleException(e);
    } finally {
      isBranchLoading.value = false;
    }
  }

  void onBranchChanged(IdNameModel? branch) {
    selectedBranch.value = branch;
    if (branch != null) fetchDisburmentList();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Main fetch – CO path kept exactly as the old implementation
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> fetchDisburmentList() async {
    try {
      isLoading.value = true;

      Map<String, dynamic> param;

      if (isBmOrCeo) {
        // BM / CEO: filter by the branch selected in the dropdown
        if (selectedBranch.value == null) return;
        param = {'branch_id': selectedBranch.value!.id};
      } else {
        // CO: original logic – pass user_id exactly as before
        int? user_id = await getUserId();
        param = {'user_id': user_id};
      }

      final res = await Get.find<ApiService>().get(
        EndPoints.disbursement,
        queryParameters: param,
        isShowLoading: true,
      );

      final data = getPropertyFromJson(res.data, 'data');
      disburment.value = List.from(
        (data as List).map((e) => DisbursementListModel.fromJson(e)).toList(),
      );
      totalClient.text =
          getPropertyFromJson(res.data, 'totalClient')?.toString() ?? '0';
      totalAmount.text = formatCurrency(
        getPropertyFromJson(res.data, 'totalDisbursement')?.toString() ?? '0',
      );
      isDone = true;
      DialogManager.hideLoading();
    } catch (e) {
      if (isClosed) return;
      ExceptionHandler.handleException(e);
    } finally {
      isLoading.value = false; // fix: was setting isBranchLoading in new code
    }
  }
}
