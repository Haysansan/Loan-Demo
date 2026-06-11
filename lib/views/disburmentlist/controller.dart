// import 'package:apploan/models/disbursement/model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:apploan/core/core.dart';
// import 'package:apploan/models/models.dart';
// import 'package:apploan/views/views.dart';
// import 'package:intl/intl.dart';

// class DisburmentListController extends GetxController {
//   final TextEditingController searchCtl = TextEditingController();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   final RxList<DisbursementListModel> disburment =
//       <DisbursementListModel>[].obs;
//   final RxBool isLoading = false.obs;
//   final TextEditingController totalClient = TextEditingController();
//   final TextEditingController totalAmount = TextEditingController();

//   // ── BM / CEO only – commented out (branch selection no longer used) ──
//   // final RxBool isBranchLoading = false.obs;
//   // final RxList<IdNameModel> branchList = <IdNameModel>[].obs;
//   // final Rxn<IdNameModel> selectedBranch = Rxn<IdNameModel>();

//   bool isDone = false;
//   final StartController startCtl = Get.find<StartController>();

//   /// True when the logged-in user is Branch Manager or CEO.
//   bool get isBmOrCeo =>
//       UserRepository.shared.isBM || UserRepository.shared.isEco;

//   // ─────────────────────────────────────────────────────────────────────────
//   // Lifecycle
//   // ─────────────────────────────────────────────────────────────────────────

//   @override
//   void onInit() {
//     fetchDisburmentList(); // same entry point for all roles
//     super.onInit();
//   }

//   @override
//   void onClose() {
//     searchCtl.dispose();
//     totalClient.dispose();
//     totalAmount.dispose();
//     super.onClose();
//   }

//   // ─────────────────────────────────────────────────────────────────────────
//   // Helpers
//   // ─────────────────────────────────────────────────────────────────────────

//   String formatCurrency(String amount) {
//     // ignore: unnecessary_null_comparison
//     return amount != null
//         ? '${NumberFormat.currency(locale: 'en_US', symbol: '').format(double.parse(amount))}'
//             .replaceAll('.00', ' រៀល')
//         : 'N/A';
//   }

//   // show branch_id stored at login
//   Future<int?> getbranchId() async {
//     int? branchId = await SharedPreferencesManager.getIntValue('branch_id');
//     return branchId;
//   }

//   // show user_id stored at login
//   Future<int?> getUserId() async {
//     int? user_id = await SharedPreferencesManager.getIntValue('user_id');
//     return user_id;
//   }

//   // ─────────────────────────────────────────────────────────────────────────
//   // BM / CEO – branch dropdown (commented out – no longer used)
//   // ─────────────────────────────────────────────────────────────────────────

//   // Future<void> fetchBranches() async {
//   //   try {
//   //     isBranchLoading.value = true;
//   //     final res = await Get.find<ApiService>().get(
//   //       EndPoints.getBranches,
//   //       isShowLoading: false,
//   //     );
//   //     final data = getPropertyFromJson(res.data, 'data');
//   //     branchList.value = List<IdNameModel>.from(
//   //       (data as List).map(
//   //         (e) => IdNameModel(id: e['id'] ?? 0, name: e['name'] ?? 'N/A'),
//   //       ),
//   //     );
//   //   } catch (e) {
//   //     if (isClosed) return;
//   //     ExceptionHandler.handleException(e);
//   //   } finally {
//   //     isBranchLoading.value = false;
//   //   }
//   // }

//   // void onBranchChanged(IdNameModel? branch) {
//   //   selectedBranch.value = branch;
//   //   if (branch != null) fetchDisburmentList();
//   // }

//   // ─────────────────────────────────────────────────────────────────────────
//   // Main fetch – unified for all roles (CO path kept exactly as before;
//   // BM/CEO now also passes branch_id + permission so the API filters correctly)
//   // ─────────────────────────────────────────────────────────────────────────

//   // Future<void> fetchDisburmentList() async {
//   //   try {
//   //     int? user_id = await getUserId();
//   //     int? branchId = await getbranchId();
//   //     isLoading.value = true;

//   //     // Collect loan IDs that are still in the approval pipeline
//   //     // (pending / submitted / approved) — these should NOT appear
//   //     // in the Disbursement List until they are fully disbursed.
//   //     final Set<String> inPipelineLoanIds = {};
//   //     try {
//   //       final approveRes = await Get.find<ApiService>().get(
//   //         EndPoints.disbursement,
//   //         queryParameters: {'branch_id': branchId, 'user_id': user_id},
//   //         isShowLoading: false,
//   //       );
//   //       final approveData = getPropertyFromJson(approveRes.data, 'data');
//   //       if (approveData is List) {
//   //         for (final item in approveData) {
//   //           final status = (item['status'] ?? '').toString().toLowerCase();
//   //           final loanId = item['loan_id']?.toString();
//   //           // Only exclude loans still in-flight; disbursed/rejected are fine to show
//   //           if (loanId != null &&
//   //               (status == 'pending' ||
//   //                   status == 'submitted' ||
//   //                   status == 'approved')) {
//   //             inPipelineLoanIds.add(loanId);
//   //           }
//   //         }
//   //       }
//   //     } catch (_) {
//   //       // Non-fatal — continue without filtering if this call fails
//   //     }

//   //     // Build query params based on role.
//   //     // CO:      branch_id + user_id  (original behaviour, unchanged)
//   //     // BM/CEO:  branch_id + user_id + permission=co
//   //     //          The API already scopes results by branch when permission=co
//   //     //          is supplied together with the stored branch_id / user_id.
//   //     final Map<String, dynamic> param = {
//   //       'branch_id': branchId,
//   //       'user_id': user_id,
//   //       if (isBmOrCeo) 'permission': 'co',
//   //     };

//   //     final res = await Get.find<ApiService>().get(
//   //       EndPoints.disbursement,
//   //       queryParameters: param,
//   //       isShowLoading: true,
//   //     );
//   //     final data = getPropertyFromJson(res.data, 'data');

//   //     final allItems = List<DisbursementListModel>.from(
//   //       (data as List).map((e) => DisbursementListModel.fromJson(e)),
//   //     );

//   //     // Remove loans still waiting for approval / disbursement action
//   //     disburment.value =
//   //         allItems
//   //             .where((item) => !inPipelineLoanIds.contains(item.loan_id))
//   //             .toList();

//   //     totalClient.text =
//   //         getPropertyFromJson(res.data, 'totalClient')?.toString() ?? '0';
//   //     totalAmount.text = formatCurrency(
//   //       getPropertyFromJson(res.data, 'totalDisbursement')?.toString() ?? '0',
//   //     );
//   //     isDone = true;
//   //     DialogManager.hideLoading();
//   //   } catch (e) {
//   //     if (isClosed) return;
//   //     ExceptionHandler.handleException(e);
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }
//   Future<void> fetchDisburmentList() async {
//     try {
//       int? user_id = await getUserId();
//       int? branchId = await getbranchId();
//       isLoading.value = true;

//       final Map<String, dynamic> param = {
//         'branch_id': branchId,
//         'user_id': user_id,
//         if (isBmOrCeo) 'permission': 'co',
//       };

//       final res = await Get.find<ApiService>().get(
//         EndPoints.disbursement,
//         queryParameters: param,
//         isShowLoading: true,
//       );
//       final data = getPropertyFromJson(res.data, 'data');

//       disburment.value = List<DisbursementListModel>.from(
//         (data as List).map((e) => DisbursementListModel.fromJson(e)),
//       );

//       totalClient.text =
//           getPropertyFromJson(res.data, 'totalClient')?.toString() ?? '0';
//       totalAmount.text = formatCurrency(
//         getPropertyFromJson(res.data, 'totalDisbursement')?.toString() ?? '0',
//       );
//       isDone = true;
//       DialogManager.hideLoading();
//     } catch (e) {
//       if (isClosed) return;
//       ExceptionHandler.handleException(e);
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'package:apploan/models/disbursement/disbursement.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:intl/intl.dart';
import 'package:apploan/views/views.dart';

class DisburmentListController extends GetxController {
  final TextEditingController searchCtl = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxList<DisbursementListModel> disburment =
      <DisbursementListModel>[].obs;
  final RxBool isLoading = false.obs;
  final TextEditingController totalClient = TextEditingController();
  final TextEditingController totalAmount = TextEditingController();

  bool isDone = false;
  final StartController startCtl = Get.find<StartController>();

  List<DisbursementListModel> _allItems = [];

  bool get isBmOrCeo =>
      UserRepository.shared.isBM || UserRepository.shared.isEco;

  @override
  void onInit() {
    super.onInit();
    fetchDisburmentList();
  }

  @override
  void onClose() {
    searchCtl.dispose();
    totalClient.dispose();
    totalAmount.dispose();
    super.onClose();
  }

  String formatCurrency(String amount) {
    return '${NumberFormat.currency(locale: 'en_US', symbol: '').format(double.parse(amount))}'
        .replaceAll('.00', ' រៀល');
  }

  Future<int?> _getBranchId() async =>
      SharedPreferencesManager.getIntValue('branch_id');

  Future<int?> _getUserId() async =>
      SharedPreferencesManager.getIntValue('user_id');

  void filterByName() {
    final query = searchCtl.text.trim().toLowerCase();
    if (query.isEmpty) {
      disburment.value = _allItems;
    } else {
      disburment.value =
          _allItems
              .where((item) => item.client.toLowerCase().contains(query))
              .toList();
    }
  }

  Future<void> fetchDisburmentList() async {
    try {
      isLoading.value = true;
      final userId = await _getUserId();
      final branchId = await _getBranchId();

      final res = await Get.find<ApiService>().get(
        EndPoints.disbursement,
        queryParameters: {
          'branch_id': branchId,
          'user_id': userId,
          if (isBmOrCeo) 'permission': 'co',
        },
        isShowLoading: true,
      );

      final data = getPropertyFromJson(res.data, 'data') as List;
      _allItems = data.map((e) => DisbursementListModel.fromJson(e)).toList();
      disburment.value = _allItems;

      totalClient.text =
          getPropertyFromJson(res.data, 'totalClient')?.toString() ?? '0';
      totalAmount.text = formatCurrency(
        getPropertyFromJson(res.data, 'totalDisbursement')?.toString() ?? '0',
      );
      isDone = true;
    } catch (e) {
      if (isClosed) return;
      ExceptionHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }
}
