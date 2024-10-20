import 'package:flutter/material.dart';
import 'assignment.dart';
import 'llm_service.dart';
import 'moodle_service.dart';

class AssignmentGeneratorScreen extends StatefulWidget {
  final LlmService apiService;
  final MoodleService moodleService;

  const AssignmentGeneratorScreen({
    Key? key,
    required this.apiService,
    required this.moodleService,
  }) : super(key: key);

  @override
  _AssignmentGeneratorScreenState createState() =>
      _AssignmentGeneratorScreenState();
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
        currentIndex = 0;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error generating assignments: $e';
      });
    } finally {
      setState(() {
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
        await widget.moodleService.createAssignment(
          courseId: assignment.courseId ?? '1', // Use actual course ID or handle null case
          name: assignment.name,
          description: assignment.question,
        );
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

  void _cancelAssignments() {
    setState(() {
      _promptController.clear();
      assignments.clear();
      _answerControllers.clear();
      currentIndex = 0;
      errorMessage = null;
    });
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
}