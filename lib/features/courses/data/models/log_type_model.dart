import 'activity_log_model.dart';

class LogType {
  final String id;
  final String slug;
  final String name;
  final String description;
  final String idCategoryLogType;

  LogType({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    required this.idCategoryLogType,
  });

  factory LogType.fromJson(Map<String, dynamic> json) {
    return LogType(
      id: json['id'] ?? '',
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      idCategoryLogType: json['idCategoryLogType'] ?? '',
    );
  }
}

class LogTypeResponse {
  final bool success;
  final int status;
  final String message;
  final List<LogType> data;
  final PageMeta? pageMeta;

  LogTypeResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
    this.pageMeta,
  });

  factory LogTypeResponse.fromJson(Map<String, dynamic> json) {
    return LogTypeResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data:
          (json['data'] as List?)?.map((e) => LogType.fromJson(e)).toList() ??
          [],
      pageMeta: json['pageMeta'] != null
          ? PageMeta.fromJson(json['pageMeta'])
          : null,
    );
  }
}
