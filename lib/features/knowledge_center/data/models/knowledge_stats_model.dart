class KnowledgeStatsModel {
  final int totalKnowledge;
  final int totalWebinars;
  final int totalViews;
  final int totalLikes;

  KnowledgeStatsModel({
    required this.totalKnowledge,
    required this.totalWebinars,
    required this.totalViews,
    required this.totalLikes,
  });

  factory KnowledgeStatsModel.fromJson(Map<String, dynamic> json) {
    return KnowledgeStatsModel(
      totalKnowledge: json['totalKnowledge'] ?? 0,
      totalWebinars: json['totalWebinars'] ?? 0,
      totalViews: json['totalViews'] ?? 0,
      totalLikes: json['totalLikes'] ?? 0,
    );
  }
}

class KnowledgeStatsResponse {
  final bool success;
  final int status;
  final String message;
  final KnowledgeStatsModel data;

  KnowledgeStatsResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  factory KnowledgeStatsResponse.fromJson(Map<String, dynamic> json) {
    return KnowledgeStatsResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: KnowledgeStatsModel.fromJson(json['data']['stats'] ?? {}),
    );
  }
}
