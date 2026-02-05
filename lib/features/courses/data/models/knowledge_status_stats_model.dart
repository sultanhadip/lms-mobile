class KnowledgeStatusStats {
  final int total;
  final int approvedCount;
  final int pendingCount;
  final int rejectedCount;
  final int hiddenCount;

  KnowledgeStatusStats({
    required this.total,
    required this.approvedCount,
    required this.pendingCount,
    required this.rejectedCount,
    required this.hiddenCount,
  });

  factory KnowledgeStatusStats.fromJson(Map<String, dynamic> json) {
    return KnowledgeStatusStats(
      total: json['total'] ?? 0,
      approvedCount: json['approvedCount'] ?? 0,
      pendingCount: json['pendingCount'] ?? 0,
      rejectedCount: json['rejectedCount'] ?? 0,
      hiddenCount: json['hiddenCount'] ?? 0,
    );
  }
}

class KnowledgeStatusStatsResponse {
  final bool success;
  final int status;
  final String message;
  final KnowledgeStatusStats? data;

  KnowledgeStatusStatsResponse({
    required this.success,
    required this.status,
    required this.message,
    this.data,
  });

  factory KnowledgeStatusStatsResponse.fromJson(Map<String, dynamic> json) {
    return KnowledgeStatusStatsResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? KnowledgeStatusStats.fromJson(json['data'])
          : null,
    );
  }
}
