class ActivityLog {
  final String id;
  final String timestamp;
  final String idUser;
  final String nameUser;
  final String details;
  final int? duration;
  final String slugLogType;
  final String logTypeName;
  final String categoryLogTypeName;

  ActivityLog({
    required this.id,
    required this.timestamp,
    required this.idUser,
    required this.nameUser,
    required this.details,
    this.duration,
    required this.slugLogType,
    required this.logTypeName,
    required this.categoryLogTypeName,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json['id'] ?? '',
      timestamp: json['timestamp'] ?? '',
      idUser: json['idUser'] ?? '',
      nameUser: json['nameUser'] ?? '',
      details: json['details'] ?? '',
      duration: json['duration'],
      slugLogType: json['slugLogType'] ?? '',
      logTypeName: json['logType']?['name'] ?? '',
      categoryLogTypeName: json['categoryLogType']?['name'] ?? '',
    );
  }
}

class PageMeta {
  final int page;
  final int perPage;
  final bool hasPrev;
  final bool hasNext;
  final int totalPageCount;
  final int showingFrom;
  final int showingTo;
  final int resultCount;
  final int totalResultCount;

  PageMeta({
    required this.page,
    required this.perPage,
    required this.hasPrev,
    required this.hasNext,
    required this.totalPageCount,
    required this.showingFrom,
    required this.showingTo,
    required this.resultCount,
    required this.totalResultCount,
  });

  factory PageMeta.fromJson(Map<String, dynamic> json) {
    return PageMeta(
      page: json['page'] ?? 1,
      perPage: json['perPage'] ?? 25,
      hasPrev: json['hasPrev'] ?? false,
      hasNext: json['hasNext'] ?? false,
      totalPageCount: json['totalPageCount'] ?? 1,
      showingFrom: json['showingFrom'] ?? 0,
      showingTo: json['showingTo'] ?? 0,
      resultCount: json['resultCount'] ?? 0,
      totalResultCount: json['totalResultCount'] ?? 0,
    );
  }
}

class ActivityLogResponse {
  final bool success;
  final int status;
  final String message;
  final List<ActivityLog> data;
  final PageMeta? pageMeta;

  ActivityLogResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
    this.pageMeta,
  });

  factory ActivityLogResponse.fromJson(Map<String, dynamic> json) {
    return ActivityLogResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data:
          (json['data'] as List?)
              ?.map((e) => ActivityLog.fromJson(e))
              .toList() ??
          [],
      pageMeta: json['pageMeta'] != null
          ? PageMeta.fromJson(json['pageMeta'])
          : null,
    );
  }
}
