import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FetchAttendance extends StatefulWidget {
  @override
  _FetchAttendanceState createState() => _FetchAttendanceState();
}

class _FetchAttendanceState extends State<FetchAttendance> {
  List<Map<String, dynamic>> attendanceData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.241.42/miniproject/fetch_attendance.php'));

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

  var defaulters;

  Future<void> fetchDefaulters() async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.241.42/miniproject/fetch_attendance.php'));

      if (response.statusCode == 200) {
        setState(() {
          defaulters = (json.decode(response.body) as List<dynamic>)
              .cast<Map<String, dynamic>>();
        });
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

  Future<void> generatePdf() async {
    fetchDefaulters();

    try {
      final response = await http.get(Uri.parse('http://localhost:5080/pdf'));

      if (response.statusCode == 200) {
        // Save the PDF file locally or handle it as needed
        final Uint8List pdfBytes = response.bodyBytes;
        final directory = await getTemporaryDirectory();
        final filePath = join(directory.path, "pdf_creation.pdf");
        final file = File(filePath);
        await file.writeAsBytes(pdfBytes);

        print("PDF downloaded at: ${file.path}");
      } else {
        print('Failed to fetch PDF');
      }
    } catch (e) {
      print('Error fetching PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Defaulters'),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: generatePdf,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: attendanceData.length,
        itemBuilder: (context, index) {
          final rollNo = attendanceData[index]['roll_no'];
          final attendancePercentage =
              attendanceData[index]['attendance_percentage'];

          return Column(
            children: [
              ListTile(
                title: Text('Roll No: $rollNo'),
                subtitle: Text('Attendance Percentage: $attendancePercentage%'),
              ),
              Divider(
                height: 10,
                color: Colors.blue,
              ),
            ],
          );
        },
      ),
    );
  }
}
