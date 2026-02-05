import 'activity_log_model.dart';

class CategoryLogType {
  final String id;
  final String name;
  final String description;

  CategoryLogType({
    required this.id,
    required this.name,
    required this.description,
  });

  factory CategoryLogType.fromJson(Map<String, dynamic> json) {
    return CategoryLogType(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class CategoryLogTypeResponse {
  final bool success;
  final int status;
  final String message;
  final List<CategoryLogType> data;
  final PageMeta? pageMeta;

  CategoryLogTypeResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
    this.pageMeta,
  });

  factory CategoryLogTypeResponse.fromJson(Map<String, dynamic> json) {
    return CategoryLogTypeResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data:
          (json['data'] as List?)
              ?.map((e) => CategoryLogType.fromJson(e))
              .toList() ??
          [],
      pageMeta: json['pageMeta'] != null
          ? PageMeta.fromJson(json['pageMeta'])
          : null,
    );
  }
}
