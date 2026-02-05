import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/knowledge_stats_model.dart';
import '../models/knowledge_subject_model.dart';
import '../models/knowledge_content_model.dart';

class KnowledgeService {
  static const String baseUrl =
      'https://gatewaylms-dev.etc-nso.id/course/api/v1';

  Future<KnowledgeSubjectResponse> getKnowledgeSubjects() async {
    final url = Uri.parse('$baseUrl/knowledge-subjects?page=1&perPage=20');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return KnowledgeSubjectResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load subjects: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching subjects: $e');
    }
  }

  Future<KnowledgeListResponse> getKnowledgeList({
    int page = 1,
    int perPage = 10,
    String? orderBy,
  }) async {
    String urlString = '$baseUrl/knowledge-centers?page=$page&perPage=$perPage';
    if (orderBy == 'createdAt') {
      urlString += '&orderBy%5B0%5D%5BcreatedAt%5D=desc';
    } else {
      urlString +=
          '&orderBy%5B0%5D%5BviewCount%5D=desc&orderBy%5B1%5D%5BlikeCount%5D=desc';
    }

    final url = Uri.parse(urlString);

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return KnowledgeListResponse.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load knowledge list: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching knowledge list: $e');
    }
  }

  Future<KnowledgeStatsResponse> getKnowledgeStats() async {
    final url = Uri.parse('$baseUrl/knowledge-centers/stats');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return KnowledgeStatsResponse.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load knowledge stats: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching knowledge stats: $e');
    }
  }
}
