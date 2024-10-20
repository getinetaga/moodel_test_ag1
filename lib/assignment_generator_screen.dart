// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'assignment.dart';
import 'llm_service.dart';
import 'moodle_service.dart';

class AssignmentGeneratorScreen extends StatefulWidget {
  final LlmService apiService;
  final MoodleService moodleService;

  const AssignmentGeneratorScreen({
    super.key,
    required this.apiService,
    required this.moodleService,
  });

  @override
  _AssignmentGeneratorScreenState createState() =>
      _AssignmentGeneratorScreenState();
}

class MoodleService {
}

class _AssignmentGeneratorScreenState extends State<AssignmentGeneratorScreen> {
  final TextEditingController _promptController = TextEditingController();
  final Map<int, TextEditingController> _answerControllers = {};
  List<Assignment> assignments = [];
  bool isLoading = false;
  bool isUploading = false;
  String? errorMessage;
  int currentIndex = 0;

  Future<void> _generateAssignments() async {
    if (_promptController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a prompt';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final newAssignments =
      await widget.apiService.generateAssignments(_promptController.text);
      setState(() {
        assignments = newAssignments;
        isLoading = false;
        currentIndex = 0;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error generating assignments: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _uploadAssignmentsToMoodle() async {
    if (assignments.isEmpty) {
      setState(() {
        errorMessage = 'No assignments available to upload';
      });
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      for (var assignment in assignments) {
        final response = await widget.moodleService.createAssignment(
          courseId: '1', // Replace with actual course ID
          name: assignment.name,
          description: assignment.question,
        );
        //print('Assignment uploaded: ${response['id']}');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Assignments uploaded successfully!')),
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Error uploading assignments: $e';
      });
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: 'Enter assignment prompt',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ElevatedButton(
              onPressed: isLoading ? null : _generateAssignments,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Generate Assignment'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: assignments.isEmpty
                  ? const Center(child: Text('No assignments generated yet'))
                  : ListView.builder(
                itemCount: assignments.length,
                itemBuilder: (context, index) {
                  final assignment = assignments[index];
                  if (!_answerControllers.containsKey(index)) {
                    _answerControllers[index] = TextEditingController();
                  }

                  return Card(
                    child: ListTile(
                      title: Text(assignment.name),
                      subtitle: Text(assignment.question),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: currentIndex > 0
                    ? () {
                  setState(() {
                    currentIndex--;
                  });
                }
                    : null,
                child: const Text('Previous'),
              ),
              ElevatedButton(
                onPressed: currentIndex < assignments.length - 1
                    ? () {
                  setState(() {
                    currentIndex++;
                  });
                }
                    : null,
                child: const Text('Next'),
              ),
              ElevatedButton(
                onPressed: (assignments.isEmpty || isUploading)
                    ? null
                    : _uploadAssignmentsToMoodle,
                child: isUploading
                    ? const CircularProgressIndicator()
                    : const Text('Upload to Moodle'),
              ),
              ElevatedButton(
                onPressed: _cancelAssignments,
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _cancelAssignments() {
    setState(() {
      _promptController.clear(); // Clear the prompt input
      assignments.clear(); // Clear the assignments list
      _answerControllers.clear(); // Clear the answer controllers
      currentIndex = 0; // Reset the current index
      errorMessage = null; // Clear any error messages
    });
  }
}
