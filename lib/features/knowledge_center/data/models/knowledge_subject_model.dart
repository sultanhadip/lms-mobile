class KnowledgeSubjectModel {
  final String id;
  final String name;
  final String icon;

  KnowledgeSubjectModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory KnowledgeSubjectModel.fromJson(Map<String, dynamic> json) {
    return KnowledgeSubjectModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class KnowledgeSubjectResponse {
  final bool success;
  final int status;
  final String message;
  final List<KnowledgeSubjectModel> data;

  KnowledgeSubjectResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  factory KnowledgeSubjectResponse.fromJson(Map<String, dynamic> json) {
    return KnowledgeSubjectResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => KnowledgeSubjectModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}
