class SectionModel {
  final String id;
  final String name;
  final String description;
  final int sequence;
  final List<ContentModel> listContent;

  SectionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.sequence,
    required this.listContent,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      sequence: json['sequence'] ?? 0,
      listContent:
          (json['listContent'] as List<dynamic>?)
              ?.map((content) => ContentModel.fromJson(content))
              .toList() ??
          [],
    );
  }
}

class ContentModel {
  final String id;
  final String type;
  final String name;
  final String? description;
  final String? contentUrl;
  final int sequence;

  ContentModel({
    required this.id,
    required this.type,
    required this.name,
    this.description,
    this.contentUrl,
    required this.sequence,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      contentUrl: json['contentUrl'],
      sequence: json['sequence'] ?? 0,
    );
  }
}

class CourseContentResponse {
  final bool success;
  final int status;
  final String message;
  final List<SectionModel> listSection;

  CourseContentResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.listSection,
  });

  factory CourseContentResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return CourseContentResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      listSection:
          (data['listSection'] as List<dynamic>?)
              ?.map((section) => SectionModel.fromJson(section))
              .toList() ??
          [],
    );
  }
}
