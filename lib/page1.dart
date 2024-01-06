import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //dependency intl: ^0.18.1
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  static String formattedDateTime =
      "${DateFormat('dd-MM-yyyy').format(DateTime.now())}_${TimeOfDay.now().hour}:${TimeOfDay.now().minute}";

  get formattedDate_ => null;

  // Move the theme-related data to the build method
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      //backgroundColor: Colors.white38,

      appBar: AppBar(
        title: Text('Input Attendance'),

        // Use the theme for styling
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'images/attendanceBgMP.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    height: 50.0,
                    width: 250.0,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0.0, 20.0),
                              blurRadius: 30.0,
                              color: Colors.black12)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.0)),
                    child: Row(
                      children: [
                        Container(
                          height: 50.0,
                          width: 200.0,
                          padding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 12.0),
                          child: Text(
                            'Date',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.apply(color: Colors.black),
                            textScaleFactor: 1.3,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(95.0),
                                topLeft: Radius.circular(95.0),
                                bottomRight: Radius.circular(200.0),
                              )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.search,
                            size: 30.0, color: Colors.lightBlueAccent)
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                InkWell(
                  onTap: () => _selectTime(context), // ()=>null,
                  child: Container(
                    height: 50.0,
                    width: 250.0,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0.0, 20.0),
                              blurRadius: 30.0,
                              color: Colors.black12)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.0)),
                    child: Row(
                      children: [
                        Container(
                          height: 50.0,
                          width: 200.0,
                          padding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 12.0),
                          child: Text(
                            'Time',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.apply(color: Colors.black),
                            textScaleFactor: 1.3,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.purpleAccent,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(95.0),
                                topLeft: Radius.circular(95.0),
                                bottomRight: Radius.circular(200.0),
                              )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.timelapse_rounded,
                            size: 30.0, color: Colors.purpleAccent)
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                InkWell(
                  onTap: () {
                    _formatAndPostData(); // Start the data processing, but don't wait for it

                    // Navigate to the next page (MyApp) without waiting for data processing to complete
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()),
                    );
                  },
                  splashColor:
                      Colors.transparent, // Set splashColor to transparent
                  highlightColor:
                      Colors.transparent, // Set highlightColor to transparent

                  child: Container(
                    height: 50.0,
                    width: 250.0,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0.0, 20.0),
                              blurRadius: 30.0,
                              color: Colors.black12)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.0)),
                    child: Row(
                      children: [
                        Container(
                          height: 50.0,
                          width: 200.0,
                          padding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 12.0),
                          child: Text(
                            'Done',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.apply(color: Colors.black),
                            textScaleFactor: 1.3,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(95.0),
                                topLeft: Radius.circular(95.0),
                                bottomRight: Radius.circular(200.0),
                              )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.account_circle_outlined,
                            size: 30.0, color: Colors.greenAccent)
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Date and Time :  $formattedDateTime ',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      // color: theme.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _updateFormattedDateTime() {
    final formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);

    formattedDateTime =
        "${formattedDate}_${selectedTime.hour}:${selectedTime.minute}";
    print(formattedDateTime);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _updateFormattedDateTime();
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        _updateFormattedDateTime();
      });
    }
  }

  void _formatAndPostData() async {
    final url = Uri.parse('http://127.0.0.1:5080/date');

    final response = await http.post(
      url,
      body: {'date': formattedDateTime},
    );

    if (response.statusCode == 200) {
      print('Data posted successfully');
    } else {
      print('Failed to post data. Status code: ${response.statusCode}');
    }
  }
}

Future<void> postData(Map<String, int> inputData) async {
  final url = Uri.parse('http://127.0.0.1:5080/putdata');
  final headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(inputData),
  );

  if (response.statusCode == 200) {
    print(inputData);
    print('Data updated successfully');
  } else {
    print('Failed to update data. Status code: ${response.statusCode}');
  }
}

Future<List<Student>> fetchStudents() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:5080/takedata'));

  if (response.statusCode == 200) {
    List<dynamic> jsonList = json.decode(response.body);
    print(_Page1State.formattedDateTime);
    //  print("done");
    print(jsonList);
    return jsonList
        .map((studentJson) =>
            Student.fromJson(studentJson, _Page1State.formattedDateTime))
        .toList();
  } else {
    throw Exception('Failed to load students');
  }
}

class Student {
  final int rollNo;
  final String name;
  final String status;
  // Initialize based on 'status'

  Student({
    required this.rollNo,
    required this.name,
    required this.status,
    // Add a parameter for the date and time
  });

  factory Student.fromJson(Map<String, dynamic> json, String dt) {
    // Assuming that `json` is a list of maps
    print(json.length);
    if (json.length >= 3) {
      final int rollNo = json['1'];
      final String name = json['2'];
      final String status =
          json['3'] ?? 'P'; // Default to 'P' if status is undefined

      return Student(
        rollNo: rollNo,
        name: name,
        status: status,
      );
    } else {
      final int rollNo = json['roll_no'];
      final String name = json['name'];
      const String status = 'P'; // Default to 'P' if status is undefined

      return Student(
        rollNo: rollNo,
        name: name,
        status: status,
      );
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Student>> futureStudents;

  // Map to store checkbox values with rollNo as the key
  Map<int, bool> checkboxValues = {};

  @override
  void initState() {
    super.initState();
    futureStudents = fetchStudents();
    print("list aya");
    print(futureStudents);

    // Initialize checkbox values as all students are present
    futureStudents.then((students) {
      for (var student in students) {
        print(student.status);
        if (student.status == 'A') {
          checkboxValues[student.rollNo] = false;
        } else {
          checkboxValues[student.rollNo] = true;
        }
      }
    });
  }

  void updateCheckboxValue(int rollNo, bool value) {
    setState(() {
      checkboxValues[rollNo] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absence Analyser',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Absence Analyser'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Define the action to perform when the back button is pressed
              // For example, you can use Navigator to pop the current screen
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
          child: FutureBuilder<List<Student>>(
            future: futureStudents,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return Column(
                  children: [
                    Text('Student Datails'),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Roll No')),
                              DataColumn(label: Text('Status')),
                            ],
                            rows: snapshot.data!.map((student) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(student.name)),
                                  DataCell(Text(student.rollNo.toString())),
                                  DataCell(
                                    Checkbox(
                                      value: checkboxValues[student.rollNo] ??
                                          true,
                                      onChanged: (bool? value) {
                                        updateCheckboxValue(
                                            student.rollNo, value ?? true);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Convert the checkboxValues map to the desired JSON format
                        Map<String, int> inputData = {};
                        for (var student in snapshot.data!) {
                          inputData[student.rollNo.toString()] =
                              checkboxValues[student.rollNo]! ? 1 : 0;
                        }

                        // Send a POST request with the inputData
                        await postData(inputData);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Attendance Added Successfully"),
                            duration: Duration(
                                seconds: 2), // Adjust the duration as needed
                          ),
                        );
                      },
                      child: Text('Submit'),
                    ),
                  ],
                );
              } else {
                return const Text('No data available');
              }
            },
          ),
        ),
      ),
    );
  }
}
