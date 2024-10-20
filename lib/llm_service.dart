import 'dart:convert'; // Make sure to import required packages
import 'package:http/http.dart' as http; // Import the http package
import 'assignment.dart'; // Import the Assignment class

class LlmService {
  final String apiKey;

  LlmService(this.apiKey);

  // Method to generate assignments
  Future<List<Assignment>> generateAssignments(String prompt) async {
    final response = await http.post(
      Uri.parse('YOUR_API_ENDPOINT'), // Ensure to replace with your actual endpoint
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'prompt': prompt,
        // Add other parameters required by your API
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Assuming the API returns a List of assignments in the response
      return (data['assignments'] as List)
          .map((assignmentJson) => Assignment.fromJson(assignmentJson))
          .toList();
    } else {
      throw Exception('Failed to generate assignments: ${response.statusCode}');
    }
  }
}
