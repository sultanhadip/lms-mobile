class LogStats {
  final int totalLogs;
  final int activeUsers;
  final String mostActive;
  final int todayCount;
  final int weekCount;

  LogStats({
    required this.totalLogs,
    required this.activeUsers,
    required this.mostActive,
    required this.todayCount,
    required this.weekCount,
  });

  factory LogStats.fromJson(Map<String, dynamic> json) {
    return LogStats(
      totalLogs: json['totalLogs'] ?? 0,
      activeUsers: json['activeUsers'] ?? 0,
      mostActive: json['mostActive'] ?? 'N/A',
      todayCount: json['todayCount'] ?? 0,
      weekCount: json['weekCount'] ?? 0,
    );
  }
}

class LogStatsResponse {
  final bool success;
  final int status;
  final String message;
  final LogStats data;

  LogStatsResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  factory LogStatsResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data']['stats'] ?? {};
    return LogStatsResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: LogStats.fromJson(dataJson),
    );
  }
}
