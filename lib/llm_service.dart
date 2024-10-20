import 'dart:convert';
import 'package:http/http.dart' as http;
import 'assignment.dart';

class LlmService {
  final String apiKey;

  LlmService(this.apiKey);

  Future<List<Assignment>> generateAssignments(String prompt) async {
    final response = await http.post(
      Uri.parse('YOUR_API_ENDPOINT'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'prompt': prompt,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['assignments'] as List)
          .map((assignmentJson) => Assignment.fromJson(assignmentJson))
          .toList();
    } else {
      throw Exception('Failed to generate assignments: ${response.statusCode}');
    }
  }
}