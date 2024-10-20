import 'package:flutter/material.dart';

class ViewCourseContents extends StatefulWidget {
  final String courseName;

  ViewCourseContents(this.courseName);

  @override
  State createState() {
    return _CourseState(courseName);
  }
}

class _CourseState extends State<ViewCourseContents> {
  final String courseName;

  _CourseState(this.courseName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Course Content')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              courseName,
              style: TextStyle(fontSize: 64),
            ),
            ContentCarousel(
              type: 'assessment',
              onCardTap: (String cardType) {
                _showAssessmentDetails(cardType);
              },
            ),
            ContentCarousel(
              type: 'essay',
              onCardTap: (String cardType) {
                _showEssayDetails(cardType);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CreateButton(type: 'assessment'),
                CreateButton(type: 'essay'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAssessmentDetails(String cardType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assessment Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Details for $cardType'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to assessment editing page
              },
              child: Text('Edit Assessment'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEssayDetails(String cardType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Essay Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Details for $cardType'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to submissions page
              },
              child: Text('Submissions'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to assignment editing page
              },
              child: Text('Edit Essay'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

class ContentCarousel extends StatelessWidget {
  final String type;
  final Function(String) onCardTap;

  ContentCarousel({required this.type, required this.onCardTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Carousel for $type'),
        GestureDetector(
          onTap: () => onCardTap(type),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Tap for $type details'),
            ),
          ),
        ),
      ],
    );
  }
}

class CreateButton extends StatelessWidget {
  final String type;

  CreateButton({required this.type});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to create page for essays or assessments
      },
      child: Text('Create $type'),
    );
  }
}