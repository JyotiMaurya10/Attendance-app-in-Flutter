import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class attendance extends StatelessWidget {
  final GlobalKey<_AttendanceListState> _attendanceListKey =
      GlobalKey<_AttendanceListState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Teacher Attendance App'),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                _attendanceListKey.currentState?.submitAttendance();
              },
            ),
            IconButton(
              icon: Icon(Icons.group),
              onPressed: () {
                _attendanceListKey.currentState?.toggleMarkAll();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: AttendanceList(key: _attendanceListKey),
        ),
      ),
    );
  }
}

class AttendanceList extends StatefulWidget {
  AttendanceList({Key? key}) : super(key: key);

  @override
  _AttendanceListState createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  List<Student> students = List.generate(
      66, (index) => Student(index + 1, 'Student ${index + 1}', false));

  bool isAllPresent = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Checkbox(
          value: isAllPresent,
          onChanged: (value) {
            setState(() {
              isAllPresent = value!;
              markAll(value);
            });
          },
        ),
        for (var student in students)
          ListTile(
            title: Row(
              children: [
                Checkbox(
                  value: student.isPresent,
                  onChanged: (value) {
                    setState(() {
                      student.isPresent = value!;
                    });
                  },
                ),
                Text('Roll No: ${student.rollNo} - ${student.name}'),
              ],
            ),
          ),
        ElevatedButton(
          onPressed: () {
            submitAttendance();
          },
          child: Text('Submit Attendance'),
        ),
      ],
    );
  }

  void markAll(bool value) {
    for (var student in students) {
      student.isPresent = value;
    }
    setState(() {});
  }

  void toggleMarkAll() {
    markAll(!isAllPresent);
  }

  //notused
  void submitAttendance() async {
    final url = 'http://your_server/submit_attendance.php';

    final List<Map<String, dynamic>> attendanceData = students
        .map((student) => {
              'roll_no': student.rollNo,
              'date': DateTime.now().toString(),
              'attendance_status': student.isPresent ? 'Present' : 'Absent',
            })
        .toList();

    final response = await http.post(
      Uri.parse(url),
      body: {'attendance_data': json.encode(attendanceData)},
    );

    if (response.statusCode == 200) {
      print('Attendance submitted successfully');
    } else {
      print('Error: ${response.statusCode}');
    }
  }
}

class Student {
  int rollNo;
  String name;
  bool isPresent;

  Student(this.rollNo, this.name, this.isPresent);
}
