class DistrictModel {
  final String name_en;
  final String name;
  final int id;
  final int synced;

  DistrictModel({
    required this.name_en,
    required this.name,
    required this.id,
    required this.synced,
  });
  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
        name_en: json["name_en"] ?? 'N/A',
        name: json["name"] ?? 'N/A',
        id: json["id"] ?? 0,
        synced: json["synced"] ?? 0
    );
  }
}
