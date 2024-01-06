import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pw;
import 'package:pdf/widgets.dart' as pw;

import 'main.dart';

class TaskApp extends StatefulWidget {
  @override
  _TaskAppState createState() => _TaskAppState();
}

class _TaskAppState extends State<TaskApp> {
  final TextEditingController taskController = TextEditingController();
  final String rollNo =
      '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66';

  // final String rollNo = '1 2 3 4 5 41';
  List<Map<String, dynamic>> attendanceData = [];
  List<Map<String, dynamic>> defaulters = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDefaulters();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.1.42/miniproject/fetch_attendance.php'));

      if (response.statusCode == 200) {
        setState(() {
          attendanceData = (json.decode(response.body) as List<dynamic>)
              .cast<Map<String, dynamic>>();
          print(attendanceData);
        });
      } else {
        throw Exception('Failed to load attendance data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchDefaulters() async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.241.42/miniproject/fetch_attendance.php'));

      if (response.statusCode == 200) {
        setState(() {
          defaulters = (json.decode(response.body) as List<dynamic>)
              .cast<Map<String, dynamic>>();
        });

        // After fetching defaulters, post the data to 'http://localhost:5080/takedata'
        await postDefaulters(defaulters);
      } else {
        print('Failed to fetch defaulters');
      }
    } catch (e) {
      print('Error fetching defaulters: $e');
    }
  }

  Future<void> postDefaulters(List<Map<String, dynamic>> defaulters) async {
    final url = Uri.parse('http://localhost:5080/dpdf');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type':
              'application/json', // Specify the content type as JSON
        },
        body: json.encode(defaulters), // Encode defaulters as JSON
      );

      print('Post Defaulters Status Code: ${response.statusCode}');
      print('Post Defaulters Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('Defaulters data posted successfully');
      } else {
        print('Failed to post defaulters data');
      }
    } catch (e) {
      print('Error posting defaulters data: $e');
    }
  }

  Future<void> submitTask() async {
    final url = Uri.parse('http://localhost:5080/mail');

    final Map<String, String> requestData = {
      'task': taskController.text,
      'roll_no': rollNo,
    };

    try {
      final response = await http.post(
        url,
        body: requestData,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('Task Done');
        fetchDefaulters(); // Fetch defaulters after submitting a task.
      } else {
        print('Failed to post task to API');
      }
    } catch (e) {
      print('Error submitting task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Task'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
              // Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: TextFormField(
                  controller: taskController,
                  maxLines: null,
                  decoration: InputDecoration(labelText: 'Enter Task'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: submitTask,
                child: Text('Submit Task'),
              ),
              SizedBox(height: 20),
              Text(
                'Defaulters :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: defaulters.length,
                  itemBuilder: (context, index) {
                    final rollNo = defaulters[index]['roll_no'];
                    final attendancePercentage =
                        defaulters[index]['attendance_percentage'];

                    return Column(
                      children: [
                        ListTile(
                          title: Text('Roll No: $rollNo'),
                          subtitle: Text(
                              'Attendance Percentage: $attendancePercentage%'),
                        ),
                        Divider(
                          height: 10,
                          color: Colors.blue,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
