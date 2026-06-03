import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApproveLoansController extends GetxController {
  // ─── Role ───
  final Rx<UserType?> userRole = Rx<UserType?>(null);

  bool get isBM => userRole.value == UserType.bm;
  bool get isCEO => userRole.value == UserType.eco;

  // ─── State ───
  // BM tabs: 0 = View All, 1 = Verify Loans, 2 = Disbursement
  // CEO tabs: 0 = View All, 1 = accept Loan
  final RxInt selectedTab = 1.obs;
  final RxBool isLoading = false.obs;

  // ─── Loan lists ───
  final RxList<LoanApprovalModel> allLoans = <LoanApprovalModel>[].obs;
  final RxList<LoanApprovalModel> verifyLoans = <LoanApprovalModel>[].obs;
  final RxList<LoanApprovalModel> disbursementLoans = <LoanApprovalModel>[].obs;
  final RxList<LoanApprovalModel> acceptLoans = <LoanApprovalModel>[].obs;

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

  Future<UserType?> _getRole() async {
    final roleKey = await SharedPreferencesManager.get(
      Credential.permission.name,
    );
    if (roleKey == null || roleKey is! String) return null;
    try {
      return UserType.values.firstWhere((e) => e.name == roleKey);
    } catch (_) {
      return null;
    }
  }

  // ─── Which list is currently visible ───
  List<LoanApprovalModel> get currentList {
    if (isCEO) {
      return selectedTab.value == 0 ? allLoans : acceptLoans;
    }
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

  // ─── App bar title based on selected tab ───
  String get currentTitle {
    if (isCEO) {
      return selectedTab.value == 0
          ? LocaleKeys.viewAllLoans.tr
          : LocaleKeys.approveLoan.tr;
    }
    switch (selectedTab.value) {
      case 1:
        return LocaleKeys.verifyLoan.tr;
      case 2:
        return LocaleKeys.disburseLoan.tr;
      default:
        return LocaleKeys.viewAllLoans.tr;
    }
  }

  int get allCount => allLoans.length;
  int get verifyCount => verifyLoans.length;
  int get disbursementCount => disbursementLoans.length;
  int get acceptCount => acceptLoans.length;

  @override
  void onInit() {
    super.onInit();
    _initRole();
  }

  @override
  void onClose() {
    searchCtl.dispose();
    for (final c in _commentControllers.values) {
      c.dispose();
    }
    super.onClose();
  }

  /// Resolves role first, then fetches. isLoading covers the whole sequence
  /// so the view never shows an empty state during role resolution.
  Future<void> _initRole() async {
    try {
      isLoading.value = true;
      userRole.value = await _getRole();
      await _fetchForRole();
    } catch (e) {
      if (isClosed) return;
      ExceptionHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Fetch ───

  Future<void> fetchLoans() async {
    try {
      isLoading.value = true;
      await _fetchForRole();
    } catch (e) {
      if (isClosed) return;
      ExceptionHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchForRole() async {
    if (isBM) {
      await Future.wait([_fetchBMVerifyList(), _fetchBMDisbursementList()]);
    } else if (isCEO) {
      await _fetchCEOPendingList();
    }
    // If role is still null (e.g. not BM or CEO), do nothing — list stays empty.
  }

  /// BM – Verify Loans tab  (loan/get_disburse_list)
  /// pending            → verifyLoans
  /// disbursed|rejected → allLoans (View All)
  Future<void> _fetchBMVerifyList() async {
    final branchId = await _getBranchId();
    final userId = await _getUserId();

    final res = await Get.find<ApiService>().get(
      EndPoints.disbursement,
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
        parsed
            .where(
              (l) =>
                  l.status.toLowerCase() == 'disbursed' ||
                  l.status.toLowerCase() == 'rejected',
            )
            .toList();
  }

  /// BM – Disbursement tab  (loan/get_approve_disburse)
  /// CEO-approved loans ready for BM to disburse.
  Future<void> _fetchBMDisbursementList() async {
    final branchId = await _getBranchId();
    final userId = await _getUserId();

    final res = await Get.find<ApiService>().get(
      EndPoints.getPendingApproval,
      queryParameters: {'branch_id': branchId, 'user_id': userId},
      isShowLoading: false,
    );

    final raw = getPropertyFromJson(res.data, 'data');
    disbursementLoans.value = List<LoanApprovalModel>.from(
      (raw as List).map((e) => LoanApprovalModel.fromJson(e)),
    );
  }

  /// CEO – Accept Loan + View All  (loan/get_approve_disburse)
  /// pending            → acceptLoans
  /// disbursed|rejected → allLoans (View All)
  Future<void> _fetchCEOPendingList() async {
    final branchId = await _getBranchId();
    final userId = await _getUserId();

    final res = await Get.find<ApiService>().get(
      EndPoints.getPendingApproval,
      queryParameters: {'branch_id': branchId, 'user_id': userId},
      isShowLoading: false,
    );

    final raw = getPropertyFromJson(res.data, 'data');
    final parsed = List<LoanApprovalModel>.from(
      (raw as List).map((e) => LoanApprovalModel.fromJson(e)),
    );

    acceptLoans.value =
        parsed.where((l) => l.status.toLowerCase() == 'pending').toList();

    allLoans.value =
        parsed
            .where(
              (l) =>
                  l.status.toLowerCase() == 'disbursed' ||
                  l.status.toLowerCase() == 'rejected',
            )
            .toList();
  }

  // ─── Search ───

  void search() {
    final query = searchCtl.text.trim().toLowerCase();
    if (query.isEmpty) {
      fetchLoans();
      return;
    }

    bool matches(LoanApprovalModel l) =>
        l.client.toLowerCase().contains(query) ||
        l.clientCode.toLowerCase().contains(query);

    switch (selectedTab.value) {
      case 0:
        allLoans.value = allLoans.where(matches).toList();
        break;
      case 1:
        if (isCEO) {
          acceptLoans.value = acceptLoans.where(matches).toList();
        } else {
          verifyLoans.value = verifyLoans.where(matches).toList();
        }
        break;
      case 2:
        disbursementLoans.value = disbursementLoans.where(matches).toList();
        break;
    }
  }

  void clearSearch() {
    searchCtl.clear();
    fetchLoans();
  }

  // ─── BM: Verify Loan (approve sends to CEO) ───

  Future<void> verifyLoan(LoanApprovalModel loan) async {
    DialogManager.showCustom(
      PrimaryDialog(
        title: 'Confirm Verification',
        subTitle:
            'Are you sure you want to verify the loan for ${loan.client}? It will be sent to CEO for approval.',
        btnText: 'VERIFY',
        onPressed: () async {
          Get.back();
          await _sendVerify(loan);
        },
      ),
    );
  }

  Future<void> _sendVerify(LoanApprovalModel loan) async {
    try {
      final comment = _commentControllers[loan.id]?.text ?? '';
      await Get.find<ApiService>().post(EndPoints.verifyLoan, {
        'loan_id': loan.loanId,
        'client_id': loan.clientId,
        'comment': comment,
        'status': 'approved',
      }, isShowLoading: true);
      DialogManager.showDialog(
        title: LocaleKeys.successfully.tr,
        subTitle: 'Loan has been verified and sent to CEO for approval.',
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

  // ─── BM: Reject from Verify tab ───

  Future<void> rejectVerifyLoan(LoanApprovalModel loan) async {
    DialogManager.showCustom(
      PrimaryDialog(
        title: 'Confirm Rejection',
        subTitle:
            'Are you sure you want to reject the loan for ${loan.client}?',
        btnText: 'REJECT',
        onPressed: () async {
          Get.back();
          await _sendVerifyRejection(loan);
        },
      ),
    );
  }

  Future<void> _sendVerifyRejection(LoanApprovalModel loan) async {
    try {
      final comment = _commentControllers[loan.id]?.text ?? '';
      await Get.find<ApiService>().post(EndPoints.verifyLoan, {
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

  // ─── BM: Disburse Loan (after CEO approval) ───

  Future<void> disburseLoan(LoanApprovalModel loan) async {
    DialogManager.showCustom(
      PrimaryDialog(
        title: 'Confirm Disbursement',
        subTitle:
            'Are you sure you want to disburse the loan for ${loan.client}?',
        btnText: 'DISBURSE',
        onPressed: () async {
          Get.back();
          await _sendDisburse(loan);
        },
      ),
    );
  }

  Future<void> _sendDisburse(LoanApprovalModel loan) async {
    try {
      final comment = _commentControllers[loan.id]?.text ?? '';
      await Get.find<ApiService>().post(EndPoints.disburseLoan, {
        'loan_id': loan.loanId,
        'client_id': loan.clientId,
        'comment': comment,
        'status': 'disbursed',
      }, isShowLoading: true);
      DialogManager.showDialog(
        title: LocaleKeys.successfully.tr,
        subTitle: 'Loan has been disbursed successfully.',
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

  // ─── BM: Reject from Disbursement tab ───

  Future<void> rejectDisbursement(LoanApprovalModel loan) async {
    DialogManager.showCustom(
      PrimaryDialog(
        title: 'Confirm Rejection',
        subTitle:
            'Are you sure you want to reject the loan for ${loan.client}?',
        btnText: 'REJECT',
        onPressed: () async {
          Get.back();
          await _sendDisburseRejection(loan);
        },
      ),
    );
  }

  Future<void> _sendDisburseRejection(LoanApprovalModel loan) async {
    try {
      final comment = _commentControllers[loan.id]?.text ?? '';
      await Get.find<ApiService>().post(EndPoints.disburseLoan, {
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

  // ─── CEO: Approve Loan ───

  Future<void> approveLoan(LoanApprovalModel loan) async {
    DialogManager.showCustom(
      PrimaryDialog(
        title: 'Confirm Approval',
        subTitle:
            'Are you sure you want to approve the loan for ${loan.client}?',
        btnText: 'APPROVE',
        onPressed: () async {
          Get.back();
          await _sendCEOApproval(loan);
        },
      ),
    );
  }

  Future<void> _sendCEOApproval(LoanApprovalModel loan) async {
    try {
      final comment = _commentControllers[loan.id]?.text ?? '';
      await Get.find<ApiService>().post(EndPoints.approveLoan, {
        'loan_id': loan.loanId,
        'client_id': loan.clientId,
        'comment': comment,
        'status': 'approved',
      }, isShowLoading: true);
      DialogManager.showDialog(
        title: LocaleKeys.successfully.tr,
        subTitle:
            'Loan has been approved and sent back to BM for disbursement.',
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

  // ─── CEO: Reject Loan ───

  Future<void> rejectLoan(LoanApprovalModel loan) async {
    DialogManager.showCustom(
      PrimaryDialog(
        title: 'Confirm Rejection',
        subTitle:
            'Are you sure you want to reject the loan for ${loan.client}?',
        btnText: 'REJECT',
        onPressed: () async {
          Get.back();
          await _sendCEORejection(loan);
        },
      ),
    );
  }

  Future<void> _sendCEORejection(LoanApprovalModel loan) async {
    try {
      final comment = _commentControllers[loan.id]?.text ?? '';
      await Get.find<ApiService>().post(EndPoints.approveLoan, {
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
