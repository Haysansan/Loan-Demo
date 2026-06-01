import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApproveLoansController extends GetxController {
  // ─── State ───
  final RxInt selectedTab =
      1.obs; // 0 = View All, 1 = Verify Loans, 2 = Disbursement
  final RxBool isLoading = false.obs;

  // ─── Loan lists per tab ───
  final RxList<LoanApprovalModel> allLoans = <LoanApprovalModel>[].obs;
  final RxList<LoanApprovalModel> verifyLoans = <LoanApprovalModel>[].obs;
  final RxList<LoanApprovalModel> disbursementLoans = <LoanApprovalModel>[].obs;

  // ─── Search ───
  final TextEditingController searchCtl = TextEditingController();

  // ─── Comment fields ───
  final Map<int, TextEditingController> _commentControllers = {};

  TextEditingController getCommentController(int loanId) {
    _commentControllers.putIfAbsent(loanId, () => TextEditingController());
    return _commentControllers[loanId]!;
  }

  // ─── Helpers ───
  Future<int?> _getBranchId() async =>
      SharedPreferencesManager.getIntValue('branch_id');

  Future<int?> _getUserId() async =>
      SharedPreferencesManager.getIntValue('user_id');

  // ─── Which list is showing ────
  List<LoanApprovalModel> get currentList {
    switch (selectedTab.value) {
      case 0:
        return allLoans;
      case 1:
        return verifyLoans;
      case 2:
        return disbursementLoans;
      default:
        return allLoans;
    }
  }

  // ─── Tab counts ───
  int get allCount => allLoans.length;
  int get verifyCount => verifyLoans.length;
  int get disbursementCount => disbursementLoans.length;

  @override
  void onInit() {
    fetchLoans();
    super.onInit();
  }

  @override
  void onClose() {
    searchCtl.dispose();
    for (final c in _commentControllers.values) {
      c.dispose();
    }
    super.onClose();
  }

  // ─── Fetch all loans ────
  Future<void> fetchLoans() async {
    try {
      final branchId = await _getBranchId();
      final userId = await _getUserId();
      isLoading.value = true;

      final res = await Get.find<ApiService>().get(
        EndPoints.repayment, //change endpoint to approval endpoint when ready
        queryParameters: {'branch_id': branchId, 'user_id': userId},
        isShowLoading: false,
      );

      final raw = getPropertyFromJson(res.data, 'data');
      final parsed = List<LoanApprovalModel>.from(
        (raw as List).map((e) => LoanApprovalModel.fromJson(e)),
      );

      verifyLoans.value =
          parsed.where((l) => l.status.toLowerCase() == 'pending').toList();

      allLoans.value =
          parsed.where((l) => l.status.toLowerCase() == 'approved').toList();

      disbursementLoans.value =
          parsed
              .where((l) => l.status.toLowerCase() == 'disbursement')
              .toList();
    } catch (e) {
      if (isClosed) return;
      ExceptionHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Search ───
  void search() {
    final query = searchCtl.text.trim().toLowerCase();
    if (query.isEmpty) {
      fetchLoans();
      return;
    }

    // Filter whichever list is currently visible
    final source = currentList;
    final filtered =
        source
            .where(
              (l) =>
                  l.client.toLowerCase().contains(query) ||
                  l.clientCode.toLowerCase().contains(query),
            )
            .toList();

    switch (selectedTab.value) {
      case 0:
        allLoans.value = filtered;
        break;
      case 1:
        verifyLoans.value = filtered;
        break;
      case 2:
        disbursementLoans.value = filtered;
        break;
    }
  }

  void clearSearch() {
    searchCtl.clear();
    fetchLoans();
  }

  // ─── Approve ───
  Future<void> approveLoan(LoanApprovalModel loan) async {
    // Show confirmation first
    DialogManager.showCustom(
      PrimaryDialog(
        title: 'Confirm Approval',
        subTitle:
            'Are you sure you want to approve the loan for ${loan.client}?',
        btnText: 'APPROVE',
        onPressed: () async {
          Get.back();
          await _sendApproval(loan);
        },
      ),
    );
  }

  Future<void> _sendApproval(LoanApprovalModel loan) async {
    try {
      final comment = _commentControllers[loan.id]?.text ?? '';

      await Get.find<ApiService>().post(EndPoints.repayment, {
        //change endpoint to approve when ready
        'loan_id': loan.loanId,
        'client_id': loan.clientId,
        'comment': comment,
        'status': 'approved',
      }, isShowLoading: true);

      DialogManager.showDialog(
        title: LocaleKeys.successfully.tr,
        subTitle: 'Loan has been approved successfully.',
        onPressed: () {
          Get.back();
          fetchLoans(); // Refresh the list
        },
      );
    } catch (e) {
      if (isClosed) return;
      ExceptionHandler.handleException(e);
    }
  }

  // ─── Reject ───
  Future<void> rejectLoan(LoanApprovalModel loan) async {
    DialogManager.showCustom(
      PrimaryDialog(
        title: 'Confirm Rejection',
        subTitle:
            'Are you sure you want to reject the loan for ${loan.client}?',
        btnText: 'REJECT',
        onPressed: () async {
          Get.back();
          await _sendRejection(loan);
        },
      ),
    );
  }

  Future<void> _sendRejection(LoanApprovalModel loan) async {
    try {
      final comment = _commentControllers[loan.id]?.text ?? '';

      await Get.find<ApiService>().post(EndPoints.repayment, {
        //change endpoint to reject when ready
        'loan_id': loan.loanId,
        'client_id': loan.clientId,
        'comment': comment,
        'status': 'rejected',
      }, isShowLoading: true);

      DialogManager.showDialog(
        title: LocaleKeys.successfully.tr,
        subTitle: 'Loan has been rejected.',
        onPressed: () {
          Get.back();
          fetchLoans();
        },
      );
    } catch (e) {
      if (isClosed) return;
      ExceptionHandler.handleException(e);
    }
  }
}
