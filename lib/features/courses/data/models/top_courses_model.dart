class TopCourseStats {
  final String id;
  final String name;
  final double rating;
  final int totalUserRating;
  final int enrollmentCount;

  TopCourseStats({
    required this.id,
    required this.name,
    required this.rating,
    required this.totalUserRating,
    required this.enrollmentCount,
  });

  factory TopCourseStats.fromJson(Map<String, dynamic> json) {
    return TopCourseStats(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalUserRating: json['totalUserRating'] ?? 0,
      enrollmentCount: json['enrollmentCount'] ?? 0,
    );
  }
}

class TopCoursesData {
  final List<TopCourseStats> topEnrolledCourses;
  final List<TopCourseStats> topRatedCourses;

  TopCoursesData({
    required this.topEnrolledCourses,
    required this.topRatedCourses,
  });

  factory TopCoursesData.fromJson(Map<String, dynamic> json) {
    return TopCoursesData(
      topEnrolledCourses:
          (json['topEnrolledCourses'] as List<dynamic>?)
              ?.map((item) => TopCourseStats.fromJson(item))
              .toList() ??
          [],
      topRatedCourses:
          (json['topRatedCourses'] as List<dynamic>?)
              ?.map((item) => TopCourseStats.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class TopCoursesResponse {
  final bool success;
  final int status;
  final String message;
  final TopCoursesData data;

  TopCoursesResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  factory TopCoursesResponse.fromJson(Map<String, dynamic> json) {
    return TopCoursesResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: TopCoursesData.fromJson(json['data'] ?? {}),
    );
  }
}
