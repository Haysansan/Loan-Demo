class LoanApprovalModel {
  final int id;
  final String client;
  final String branch;
  final String submittedAt;
  final String creditOfficer;
  final String loanAmount;
  final String interestRate;
  final String startDate;
  final String endDate;
  final String productName;
  final String status;
  final String photo;
  final String loanId;
  final String clientCode;
  final String clientId;

  LoanApprovalModel({
    required this.id,
    required this.client,
    required this.branch,
    required this.submittedAt,
    required this.creditOfficer,
    required this.loanAmount,
    required this.interestRate,
    required this.startDate,
    required this.endDate,
    required this.productName,
    required this.status,
    required this.photo,
    required this.loanId,
    required this.clientCode,
    required this.clientId,
  });

  factory LoanApprovalModel.fromJson(Map<String, dynamic> json) {
    return LoanApprovalModel(
      id: json['id'] ?? 0,
      // API may return 'client' or 'client_name'
      client: json['client'] ?? json['client_name'] ?? 'N/A',
      branch: json['branch'] ?? 'N/A',
      // API may return 'submitted_at' or 'created_at'
      submittedAt: json['submitted_at'] ?? json['created_at'] ?? 'N/A',
      creditOfficer: json['loan_officer'] ?? json['credit_officer'] ?? 'N/A',
      // Amount is stored as a string to preserve formatting
      loanAmount:
          json['principal']?.toString() ??
          json['loan_amount']?.toString() ??
          '0',
      interestRate: json['interest_rate'] ?? 'N/A',
      startDate: json['start_date'] ?? json['disbursed_on_date'] ?? 'N/A',
      endDate: json['end_date'] ?? 'N/A',
      productName: json['product_name'] ?? json['product'] ?? 'N/A',
      status: json['status'] ?? 'Pending',
      photo: json['photo'] ?? '',
      loanId: json['loan_id']?.toString() ?? '0',
      clientCode: json['client_code'] ?? 'N/A',
      clientId: json['client_id']?.toString() ?? '0',
    );
  }
}
