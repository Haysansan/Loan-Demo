import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';
import 'package:apploan/views/views.dart';

class ApproveLoansController extends GetxController {
  // ─── Role ───
  final Rx<UserType?> userRole = Rx<UserType?>(null);

  bool get isBM => userRole.value == UserType.bm;
  bool get isCEO => userRole.value == UserType.eco;

  final RxInt selectedTab = 1.obs;
  final RxBool isLoading = false.obs;

  // ─── Lists per stage ───
  final RxList<LoanApprovalModel> allLoans = <LoanApprovalModel>[].obs;
  final RxList<LoanApprovalModel> verifyLoans = <LoanApprovalModel>[].obs;
  final RxList<LoanApprovalModel> disbursementLoans = <LoanApprovalModel>[].obs;
  final RxList<LoanApprovalModel> acceptLoans = <LoanApprovalModel>[].obs;

  // ─── Search ───
  final TextEditingController searchCtl = TextEditingController();

  // ─── Per-card comment fields ────
  final Map<int, TextEditingController> _commentControllers = {};
  TextEditingController getCommentController(int loanId) =>
      _commentControllers.putIfAbsent(loanId, () => TextEditingController());

  // ─── Derived ────
  List<LoanApprovalModel> get currentList {
    if (isCEO) return selectedTab.value == 0 ? allLoans : acceptLoans;
    switch (selectedTab.value) {
      case 1:
        return verifyLoans;
      case 2:
        return disbursementLoans;
      default:
        return allLoans;
    }
  }

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

  // ─── Helpers ──────
  Future<int?> _getBranchId() =>
      SharedPreferencesManager.getIntValue('branch_id');
  Future<int?> _getUserId() => SharedPreferencesManager.getIntValue('user_id');

  Future<UserType?> _resolveRole() async {
    if (UserRepository.shared.isBM) return UserType.bm;
    if (UserRepository.shared.isEco) return UserType.eco;
    final raw = await SharedPreferencesManager.get(Credential.permission.name);
    if (raw is! String) return null;
    try {
      return UserType.values.firstWhere((e) => e.name == raw);
    } catch (_) {
      return null;
    }
  }

  // ─── Init ─────────
  @override
  void onInit() {
    super.onInit();
    _loadAllLists();
    _initRole();
  }

  @override
  void onClose() {
    searchCtl.dispose();
    for (final c in _commentControllers.values) c.dispose();
    super.onClose();
  }

  Future<void> _initRole() async {
    try {
      isLoading.value = true;
      userRole.value = await _resolveRole();
      await _loadAllLists();
    } catch (e) {
      if (isClosed) return;
      ExceptionHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Public refresh ────────
  Future<void> fetchLoans() async {
    try {
      isLoading.value = true;
      await _loadAllLists();
    } catch (e) {
      if (isClosed) return;
      ExceptionHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Central fetch — one API call, split by status ──────
  Future<void> _loadAllLists() async {
    final branchId = await _getBranchId();
    final userId = await _getUserId();

    final res = await Get.find<ApiService>().get(
      EndPoints.getApproveDisburse,
      queryParameters: {'branch_id': branchId, 'user_id': userId},
      isShowLoading: false,
    );

    final raw = getPropertyFromJson(res.data, 'data');
    if (raw == null || raw is! List) return;

    final all =
        raw
            .map((e) => LoanApprovalModel.fromJson(e as Map<String, dynamic>))
            .toList();

    // ── Status legend ───────
    // "pending"   → CO submitted, awaiting BM verification   → BM: Verify tab
    // "submitted" → BM verified, awaiting CEO approval        → CEO: Approve tab
    // "approved"  → CEO approved, awaiting BM disbursement    → BM: Disburse tab
    // "disbursed" → fully done                                → View All
    // "rejected"  → declined at any stage                     → View All

    if (isBM) {
      verifyLoans.value =
          all.where((l) => l.status.toLowerCase() == 'submitted').toList();

      disbursementLoans.value =
          all.where((l) => l.status.toLowerCase() == 'approved').toList();

      allLoans.value =
          all
              .where(
                (l) =>
                    l.status.toLowerCase() == 'disbursed' ||
                    l.status.toLowerCase() == 'rejected',
              )
              .toList();
    } else if (isCEO) {
      acceptLoans.value =
          all.where((l) => l.status.toLowerCase() == 'pending').toList();

      allLoans.value =
          all
              .where(
                (l) =>
                    l.status.toLowerCase() == 'disbursed' ||
                    l.status.toLowerCase() == 'rejected',
              )
              .toList();
    }
  }

  // ─── Search ───────
  void search() {
    final q = searchCtl.text.trim().toLowerCase();
    if (q.isEmpty) {
      fetchLoans();
      return;
    }

    bool match(LoanApprovalModel l) =>
        l.client.toLowerCase().contains(q) ||
        l.clientCode.toLowerCase().contains(q);

    switch (selectedTab.value) {
      case 0:
        allLoans.value = allLoans.where(match).toList();
        break;
      case 1:
        if (isCEO)
          acceptLoans.value = acceptLoans.where(match).toList();
        else
          verifyLoans.value = verifyLoans.where(match).toList();
        break;
      case 2:
        disbursementLoans.value = disbursementLoans.where(match).toList();
        break;
    }
  }

  void clearSearch() {
    searchCtl.clear();
    fetchLoans();
  }

  // ─── BM: Verify → "submitted" (sends to CEO) ────────────
  Future<void> verifyLoan(LoanApprovalModel loan) async {
    _confirm(
      title: 'Confirm Verification',
      body:
          'Verify loan for ${loan.client}? It will be sent to CEO for approval.',
      btnText: 'VERIFY',
      onConfirm:
          () => _postAction(
            endpoint: EndPoints.verifyLoan,
            loan: loan,
            status: 'submitted',
            successMsg: 'Loan verified and sent to CEO.',
          ),
    );
  }

  // ─── BM: Reject from Verify tab ─────────────
  Future<void> rejectVerifyLoan(LoanApprovalModel loan) async {
    _confirm(
      title: 'Confirm Rejection',
      body: 'Reject loan for ${loan.client}?',
      btnText: 'REJECT',
      onConfirm:
          () => _postAction(
            endpoint: EndPoints.verifyLoan,
            loan: loan,
            status: 'rejected',
            successMsg: 'Loan rejected.',
          ),
    );
  }

  // ─── CEO: Approve → "approved" (sends back to BM Disburse tab) ──────
  Future<void> approveLoan(LoanApprovalModel loan) async {
    _confirm(
      title: 'Confirm Approval',
      body: 'Approve loan for ${loan.client}? BM will be able to disburse it.',
      btnText: 'APPROVE',
      onConfirm:
          () => _postAction(
            endpoint: EndPoints.approveLoan,
            loan: loan,
            status: 'approved',
            successMsg: 'Loan approved and sent to BM for disbursement.',
          ),
    );
  }

  // ─── CEO: Reject ───
  Future<void> rejectLoan(LoanApprovalModel loan) async {
    _confirm(
      title: 'Confirm Rejection',
      body: 'Reject loan for ${loan.client}?',
      btnText: 'REJECT',
      onConfirm:
          () => _postAction(
            endpoint: EndPoints.approveLoan,
            loan: loan,
            status: 'rejected',
            successMsg: 'Loan rejected.',
          ),
    );
  }

  // ─── BM: Disburse → "disbursed" ──────────────
  Future<void> disburseLoan(LoanApprovalModel loan) async {
    _confirm(
      title: 'Confirm Disbursement',
      body: 'Disburse loan for ${loan.client}?',
      btnText: 'DISBURSE',
      onConfirm:
          () => _postAction(
            endpoint: EndPoints.disburseLoan,
            loan: loan,
            status: 'disbursed',
            successMsg: 'Loan disbursed successfully.',
          ),
    );
  }

  // ─── BM: Reject from Disburse tab ────────────
  Future<void> rejectDisbursement(LoanApprovalModel loan) async {
    _confirm(
      title: 'Confirm Rejection',
      body: 'Reject loan disbursement for ${loan.client}?',
      btnText: 'REJECT',
      onConfirm:
          () => _postAction(
            endpoint: EndPoints.disburseLoan,
            loan: loan,
            status: 'rejected',
            successMsg: 'Disbursement rejected.',
          ),
    );
  }

  // ─── Shared helpers ─────────
  void _confirm({
    required String title,
    required String body,
    required String btnText,
    required VoidCallback onConfirm,
  }) {
    DialogManager.showCustom(
      PrimaryDialog(
        title: title,
        subTitle: body,
        btnText: btnText,
        onPressed: () {
          Get.back();
          onConfirm();
        },
      ),
    );
  }

  Future<void> _postAction({
    required String endpoint,
    required LoanApprovalModel loan,
    required String status,
    required String successMsg,
  }) async {
    try {
      final comment = _commentControllers[loan.id]?.text.trim() ?? '';
      final userId = await _getUserId();
      final today = DateTime.now().toIso8601String().split('T')[0];

      await Get.find<ApiService>().post(endpoint, {
        'loan_id': loan.loanId,
        'client_id': loan.clientId,
        'user_id': userId,
        'verify_on_date': today,
        'approved_on_date': today,
        'disbursed_on_date': today,
        'comment': comment,
        'status': status,
      }, isShowLoading: true);

      // Optimistic update — NO fetchLoans() call here
      _moveToNextStage(loan: loan, newStatus: status);
      _refreshDashboardBadge();

      DialogManager.showDialog(
        title: LocaleKeys.successfully.tr,
        subTitle: successMsg,
        onPressed: () => Get.back(), // just close dialog, nothing else
      );
    } catch (e) {
      if (isClosed) return;
      ExceptionHandler.handleException(e);
    }
  }

  void _moveToNextStage({
    required LoanApprovalModel loan,
    required String newStatus,
  }) {
    // Remove from all active lists
    verifyLoans.removeWhere((l) => l.loanId == loan.loanId);
    disbursementLoans.removeWhere((l) => l.loanId == loan.loanId);
    acceptLoans.removeWhere((l) => l.loanId == loan.loanId);
    allLoans.removeWhere((l) => l.loanId == loan.loanId);

    final updated = LoanApprovalModel(
      id: loan.id,
      client: loan.client,
      branch: loan.branch,
      village: loan.village,
      creditOfficer: loan.creditOfficer,
      loanAmount: loan.loanAmount,
      interestRate: loan.interestRate,
      createAt: loan.createAt,
      cycle: loan.cycle,
      loanTerm: loan.loanTerm,
      status: newStatus,
      photo: loan.photo,
      loanId: loan.loanId,
      clientCode: loan.clientCode,
      clientId: loan.clientId,
      frequency: loan.frequency,
    );

    switch (newStatus.toLowerCase()) {
      // BM verified → goes to CEO's accept tab (not visible to BM)
      // Just remove from BM verify, done.
      case 'submitted':
        break;

      // CEO approved → goes to BM's disburse tab
      // (This is on CEO side, so we just remove from CEO's accept list)
      case 'approved':
        break;

      // BM disbursed → goes to View All
      case 'disbursed':
        allLoans.insert(0, updated);
        break;

      // Rejected at any stage → goes to View All
      case 'rejected':
        allLoans.insert(0, updated);
        break;
    }
  }

  void _refreshDashboardBadge() {
    try {
      final dashCtl = Get.find<DashboardController>();
      // Derive count directly from our already-updated lists — no API call
      if (isBM) {
        dashCtl.pendingApprovalCount.value = verifyCount;
      } else if (isCEO) {
        dashCtl.pendingApprovalCount.value = acceptCount;
      }
    } catch (_) {
      // DashboardController not in scope, ignore
    }
  }
}
