class CourseCategoryData {
  final String category;
  final int courseCount;

  CourseCategoryData({required this.category, required this.courseCount});

  factory CourseCategoryData.fromJson(Map<String, dynamic> json) {
    return CourseCategoryData(
      category: json['category'] ?? '',
      courseCount: json['courseCount'] ?? 0,
    );
  }
}

class CourseCategoryStats {
  final int totalCategories;
  final List<CourseCategoryData> categoryData;

  CourseCategoryStats({
    required this.totalCategories,
    required this.categoryData,
  });

  factory CourseCategoryStats.fromJson(Map<String, dynamic> json) {
    return CourseCategoryStats(
      totalCategories: json['totalCategories'] ?? 0,
      categoryData:
          (json['categoryData'] as List<dynamic>?)
              ?.map((item) => CourseCategoryData.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class CourseCategoryResponse {
  final bool success;
  final int status;
  final String message;
  final CourseCategoryStats data;

  CourseCategoryResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  factory CourseCategoryResponse.fromJson(Map<String, dynamic> json) {
    return CourseCategoryResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: CourseCategoryStats.fromJson(json['data'] ?? {}),
    );
  }
}
