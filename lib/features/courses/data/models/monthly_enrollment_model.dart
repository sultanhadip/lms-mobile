class MonthlyData {
  final int month;
  final String monthName;
  final int enrollmentCount;

  MonthlyData({
    required this.month,
    required this.monthName,
    required this.enrollmentCount,
  });

  factory MonthlyData.fromJson(Map<String, dynamic> json) {
    return MonthlyData(
      month: json['month'] ?? 0,
      monthName: json['monthName'] ?? '',
      enrollmentCount: json['enrollmentCount'] ?? 0,
    );
  }
}

class MonthlyEnrollmentData {
  final int year;
  final int totalEnrollments;
  final List<MonthlyData> monthlyData;

  MonthlyEnrollmentData({
    required this.year,
    required this.totalEnrollments,
    required this.monthlyData,
  });

  factory MonthlyEnrollmentData.fromJson(Map<String, dynamic> json) {
    return MonthlyEnrollmentData(
      year: json['year'] ?? 0,
      totalEnrollments: json['totalEnrollments'] ?? 0,
      monthlyData:
          (json['monthlyData'] as List<dynamic>?)
              ?.map((item) => MonthlyData.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class MonthlyEnrollmentResponse {
  final bool success;
  final int status;
  final String message;
  final MonthlyEnrollmentData data;

  MonthlyEnrollmentResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  factory MonthlyEnrollmentResponse.fromJson(Map<String, dynamic> json) {
    return MonthlyEnrollmentResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: MonthlyEnrollmentData.fromJson(json['data'] ?? {}),
    );
  }
}
