import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'assignment_generator_screen.dart';
import 'llm_service.dart';
import 'moodle_service.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final llmService = LlmService(dotenv.env['LLM_API_KEY']!);
    final moodleService = MoodleService(
      token: dotenv.env['MOODLE_API_TOKEN']!,
      moodleBaseUrl: dotenv.env['MOODLE_BASE_URL']!,
    );

    return MaterialApp(
      title: 'Assignment Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AssignmentGeneratorScreen(
        apiService: llmService,
        moodleService: moodleService,
      ),
    );
  }
}
