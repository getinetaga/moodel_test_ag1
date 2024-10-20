import 'package:flutter/material.dart';

enum AssignmentType { multipleChoice, trueFalse, shortAnswer, essay, code }

class Assignment {
  final String name;
  final String question;
  final AssignmentType type;
  final List<String>? options;
  String? answer;
  final String? courseId;

  Assignment({
    required this.name,
    required this.question,
    required this.type,
    this.options,
    this.answer,
    this.courseId,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      name: json['name'] ?? 'Untitled Assignment',
      question: json['question'] ?? '',
      type: _parseAssignmentType(json['type']),
      options: json['options'] != null ? List<String>.from(json['options']) : null,
      answer: json['answer'],
      courseId: json['subjectId'],
    );
  }

  static AssignmentType _parseAssignmentType(String? type) {
    switch (type?.toLowerCase()) {
      case 'multiplechoice':
        return AssignmentType.multipleChoice;
      case 'truefalse':
        return AssignmentType.trueFalse;
      case 'shortanswer':
        return AssignmentType.shortAnswer;
      case 'essay':
        return AssignmentType.essay;
      case 'code':
        return AssignmentType.code;
      default:
        return AssignmentType.shortAnswer;
    }
  }
}

class AssignmentInputWidget extends StatefulWidget {
  final List<Assignment> assignments;

  AssignmentInputWidget({Key? key, required this.assignments}) : super(key: key);

  @override
  _AssignmentInputWidgetState createState() => _AssignmentInputWidgetState();
}

class _AssignmentInputWidgetState extends State<AssignmentInputWidget> {
  final List<TextEditingController> _answerControllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each assignment
    for (var assignment in widget.assignments) {
      _answerControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    // Dispose of controllers
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildAssignmentInput(Assignment assignment, int index) {
    switch (assignment.type) {
      case AssignmentType.multipleChoice:
        return Column(
          children: assignment.options?.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: assignment.answer,
              onChanged: (value) {
                setState(() {
                  assignment.answer = value;
                });
              },
            );
          }).toList() ?? [],
        );
      case AssignmentType.shortAnswer:
        return TextField(
          controller: _answerControllers[index],
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter your answer...',
          ),
          onChanged: (value) {
            assignment.answer = value;
          },
        );
      case AssignmentType.essay:
        return TextField(
          controller: _answerControllers[index],
          maxLines: null,
          minLines: 10,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Write your essay...',
          ),
          onChanged: (value) {
            assignment.answer = value;
          },
        );
      case AssignmentType.code:
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            controller: _answerControllers[index],
            maxLines: null,
            minLines: 10,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
            ),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Write your code...',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            onChanged: (value) {
              assignment.answer = value;
            },
          ),
        );
      case AssignmentType.trueFalse:
        final trueFalseOptions = ['True', 'False'];
        return Column(
          children: trueFalseOptions.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: assignment.answer,
              onChanged: (value) {
                setState(() {
                  assignment.answer = value;
                });
              },
            );
          }).toList(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.assignments.length,
      itemBuilder: (context, index) {
        final assignment = widget.assignments[index];
        return _buildAssignmentInput(assignment, index);
      },
    );
  }
}
