import 'dart:convert';
import 'package:http/http.dart' as http;

class MoodleService {
  final String MOODLE_API_TOKEN;
  final String moodleBaseUrl;

  MoodleService({required this.MOODLE_API_TOKEN, required this.moodleBaseUrl});

  Future<void> createAssignment({required String courseId, required String name, required String description}) async {
    final response = await http.post(
      Uri.parse('$moodleBaseUrl/webservice/rest/server.php?wsfunction=core_course_create_courses&wstoken=$MOODLE_API_TOKEN&moodlewsrestformat=json'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'courses': [
          {
            'fullname': name,
            'shortname': description,
            'categoryid': courseId,
          }
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create assignment: ${response.body}');
    }
  }
}