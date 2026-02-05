class KnowledgeContentModel {
  final String id;
  final String title;
  final String description;
  final String penyelenggara;
  final String thumbnail;
  final String type; // 'webinar' or 'content'
  final String category; // 'general', etc.
  final String subject; // e.g., 'Ekonomi', 'Data Sains'
  final int viewCount;
  final int likeCount;
  final String?
  contentType; // from knowledgeContent.contentType if type is content

  KnowledgeContentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.penyelenggara,
    required this.thumbnail,
    required this.type,
    required this.category,
    required this.subject,
    required this.viewCount,
    required this.likeCount,
    this.contentType,
  });

  factory KnowledgeContentModel.fromJson(Map<String, dynamic> json) {
    String subjectName = '';
    // Handle subject being a String or directly in json if flattened,
    // but based on response it seems 'subject' field exists at root level as string.
    if (json['subject'] is String) {
      subjectName = json['subject'];
    }

    String? contentType;
    if (json['knowledgeContent'] != null && json['knowledgeContent'] is Map) {
      contentType = json['knowledgeContent']['contentType'];
    }

    return KnowledgeContentModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      penyelenggara: json['penyelenggara'] ?? 'Pusat Pendidikan dan Pelatihan',
      thumbnail: json['thumbnail'] ?? '',
      type: json['type'] ?? '',
      category: json['category'] ?? '',
      subject: subjectName,
      viewCount: json['viewCount'] ?? 0,
      likeCount: json['likeCount'] ?? 0,
      contentType: contentType,
    );
  }
}

class KnowledgeListResponse {
  final bool success;
  final int status;
  final String message;
  final List<KnowledgeContentModel> data;

  KnowledgeListResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  factory KnowledgeListResponse.fromJson(Map<String, dynamic> json) {
    return KnowledgeListResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => KnowledgeContentModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}
