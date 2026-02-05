class TotalStatistics {
  final int totalGroupCourses;
  final int totalKnowledgeCenters;
  final int totalStudentsEnrolled;
  final int totalForums;
  final int totalCourses; // Anticipating existence, or we use another source

  TotalStatistics({
    required this.totalGroupCourses,
    required this.totalKnowledgeCenters,
    required this.totalStudentsEnrolled,
    required this.totalForums,
    this.totalCourses = 0,
  });

  factory TotalStatistics.fromJson(Map<String, dynamic> json) {
    return TotalStatistics(
      totalGroupCourses: json['totalGroupCourses'] ?? 0,
      totalKnowledgeCenters: json['totalKnowledgeCenters'] ?? 0,
      totalStudentsEnrolled: json['totalStudentsEnrolled'] ?? 0,
      totalForums: json['totalForums'] ?? 0,
      totalCourses: json['totalCourses'] ?? 0,
    );
  }
}

class TotalStatisticsResponse {
  final bool success;
  final int status;
  final String message;
  final TotalStatistics data;

  TotalStatisticsResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  factory TotalStatisticsResponse.fromJson(Map<String, dynamic> json) {
    return TotalStatisticsResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: TotalStatistics.fromJson(json['data'] ?? {}),
    );
  }
}
