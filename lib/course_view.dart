import 'package:flutter/material.dart';
import 'main.dart';

class CourseList extends StatelessWidget {
  const CourseList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          elevation: 0,
          flexibleSpace: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DevLaunch()),
                      );
                    },
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Learning Lens',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
        body: SingleChildScrollView(
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            spacing: 8.0,
            runAlignment: WrapAlignment.center,
            runSpacing: 8.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            textDirection: TextDirection.ltr,
            verticalDirection: VerticalDirection.down,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    'Course List',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildCourseButton(context, 'Course 1', 'Course ID'),
              SizedBox(height: 16),
              _buildCourseButton(context, 'Course 2', 'Course ID'),
              SizedBox(height: 16),
              _buildCourseButton(context, 'Course 3', 'Course ID'),
              SizedBox(height: 16),
              _buildCourseButton(context, 'Course 4', 'Course ID'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseButton(BuildContext context, String title, String subtitle) {
    return SizedBox(
      width: 300,
      height: 150,
      child: ElevatedButton(
        onPressed: () {
          // Button onPressed Action
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFF6A5A99)),
          minimumSize: MaterialStateProperty.all(Size(250, 5)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        child: ListTile(
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            subtitle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

DevLaunch() {
}