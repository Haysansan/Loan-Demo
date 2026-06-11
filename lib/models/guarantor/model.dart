class IdTypeModel {
  final String id;
  final String name;

  IdTypeModel({required this.id, required this.name});

  factory IdTypeModel.fromJson(Map<String, dynamic> json) =>
      IdTypeModel(id: json['id'].toString(), name: json['name'] as String);

  @override
  bool operator ==(Object other) => other is IdTypeModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class GuarantorModel {
  final String fullName;
  final String? dateOfBirth;
  final String? gender;
  final String phoneNumber;
  final String idTypeId;
  final String nationalId;
  final String relationship;

  GuarantorModel({
    required this.fullName,
    this.dateOfBirth,
    this.gender,
    required this.phoneNumber,
    required this.idTypeId,
    required this.nationalId,
    required this.relationship,
  });

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'date_of_birth': dateOfBirth,
    'gender': gender,
    'phone_number': phoneNumber,
    'id_type_id': idTypeId,
    'national_id': nationalId,
    'relationship': relationship,
  };
}
