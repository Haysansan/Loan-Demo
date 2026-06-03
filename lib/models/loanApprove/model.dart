class LoanApprovalModel {
  final int id;
  final String client;
  final String branch;
  final String village;
  final String creditOfficer;
  final String loanAmount;
  final String interestRate;
  final String createAt;
  final String cycle;
  final String productName;
  final String status;
  final String photo;
  final String loanId;
  final String clientCode;
  final String clientId;
  final String frequency;

  LoanApprovalModel({
    required this.id,
    required this.client,
    required this.branch,
    required this.village,
    required this.creditOfficer,
    required this.loanAmount,
    required this.interestRate,
    required this.createAt,
    required this.cycle,
    required this.productName,
    required this.status,
    required this.photo,
    required this.loanId,
    required this.clientCode,
    required this.clientId,
    required this.frequency,
  });

  factory LoanApprovalModel.fromJson(Map<String, dynamic> json) {
    return LoanApprovalModel(
      id: json['id'] ?? 0,
      // API may return 'client' or 'client_name'
      client: json['client'] ?? json['client_name'] ?? 'N/A',
      branch: json['branch'] ?? 'N/A',
      // API may return 'submitted_at' or 'created_at'
      // submittedAt: json['submitted_at'] ?? json['created_at'] ?? 'N/A',
      creditOfficer: json['loan_officer'] ?? json['credit_officer'] ?? 'N/A',
      // Amount is stored as a string to preserve formatting
      loanAmount:
          json['principal']?.toString() ??
          json['loan_amount']?.toString() ??
          '0',
      interestRate: json['interest_rate'] ?? 'N/A',
      // start date = when loan was created
      createAt: json['created_at']?.toString().split(' ')[0] ?? 'N/A',
      // end date = cycle number
      cycle: 'វដ្តទី ${json['cycle'] ?? 'N/A'}',
      // product name from API
      productName: json['product_name'] ?? json['loan_type'] ?? 'N/A',
      // submittedAt shows village name
      village: json['villages_name'] ?? json['village_name'] ?? 'N/A',
      status: json['status'] ?? 'pending',
      photo: json['photo'] ?? '',
      loanId: json['loan_id']?.toString() ?? '0',
      clientCode: json['client_code'] ?? 'N/A',
      clientId: json['client_id']?.toString() ?? '0',
      frequency: json['loan_frequency'] ?? 'N/A',
    );
  }
}
