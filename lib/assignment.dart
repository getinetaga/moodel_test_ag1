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

// The rest of the code remains unchanged.