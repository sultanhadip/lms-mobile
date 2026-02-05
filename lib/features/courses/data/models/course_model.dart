class CourseModel {
  final String id;
  final String name;
  final double rating;
  final int totalUserRating;
  final int activityCount;
  final GroupCourse groupCourse;
  final Manager manager;
  final List<Teacher> teachers;

  CourseModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.totalUserRating,
    required this.activityCount,
    required this.groupCourse,
    required this.manager,
    required this.teachers,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalUserRating: json['totalUserRating'] ?? 0,
      activityCount: json['_count']?['listActivity'] ?? 0,
      groupCourse: GroupCourse.fromJson(json['groupCourse'] ?? {}),
      manager: Manager.fromJson(json['manager'] ?? {}),
      teachers:
          (json['teachers'] as List<dynamic>?)
              ?.map((teacher) => Teacher.fromJson(teacher))
              .toList() ??
          [],
    );
  }
}

class GroupCourse {
  final String id;
  final String title;
  final String thumbnail;
  final CourseDescription description;

  GroupCourse({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.description,
  });

  factory GroupCourse.fromJson(Map<String, dynamic> json) {
    return GroupCourse(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      description: CourseDescription.fromJson(json['description'] ?? {}),
    );
  }
}

class CourseDescription {
  final String curriculum;
  final String category;
  final String description;
  final String method;
  final String silabus;
  final int totalJp;

  CourseDescription({
    required this.curriculum,
    required this.category,
    required this.description,
    required this.method,
    required this.silabus,
    required this.totalJp,
  });

  factory CourseDescription.fromJson(Map<String, dynamic> json) {
    return CourseDescription(
      curriculum: json['curriculum'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      method: json['method'] ?? '',
      silabus: json['silabus'] ?? '',
      totalJp: _parseInt(json['totalJp']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class Manager {
  final String id;
  final String name;

  Manager({required this.id, required this.name});

  factory Manager.fromJson(Map<String, dynamic> json) {
    return Manager(id: json['id'] ?? '', name: json['name'] ?? '');
  }
}

class Teacher {
  final String id;
  final String name;

  Teacher({required this.id, required this.name});

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(id: json['id'] ?? '', name: json['name'] ?? '');
  }
}

class CourseResponse {
  final bool success;
  final int status;
  final String message;
  final List<CourseModel> data;
  final PageMeta pageMeta;

  CourseResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
    required this.pageMeta,
  });

  factory CourseResponse.fromJson(Map<String, dynamic> json) {
    return CourseResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((course) => CourseModel.fromJson(course))
              .toList() ??
          [],
      pageMeta: PageMeta.fromJson(json['pageMeta'] ?? {}),
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
      perPage: json['perPage'] ?? 8,
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
