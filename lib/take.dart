import 'package:flutter/material.dart';
import 'page1.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main.dart';
// Import for data table
import 'package:data_table_2/data_table_2.dart'; //data_table_2: ^2.5.8
import 'package:path_provider/path_provider.dart';
// Import for viewing PDFs
import 'package:flutter_pdfview/flutter_pdfview.dart'; // flutter_pdfview: ^1.3.2
// Import for working with Excel file
import 'package:excel/excel.dart' as excel; //excel: ^3.0.0

class Take extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Absence Analyser',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: TakeHomePage(),
      routes: {
        '/page1': (context) => Page1(),
        '/page3': (context) => Page3(),
      },
    );
  }
}

class TakeHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Attendance'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
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
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/page1');
                  },
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
                            'Take Attendance',
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
                        Icon(Icons.add_circle,
                            size: 30.0, color: Colors.greenAccent)
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/page1');
                  },
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
                            'Edit Attendance',
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
                        Icon(Icons.abc_sharp,
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
                    Navigator.pushNamed(context, '/page3');
                  }, // ()=>null,
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
                            'Display Details',
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
                        Icon(Icons.account_circle_rounded,
                            size: 30.0, color: Colors.lightBlueAccent)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  List<Map<String, dynamic>> data = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost:5080/details'));
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> responseData =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      setState(() {
        data = responseData;
        loading = false;
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendance Details')),
      body: Center(
        child: loading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Student Details'),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columns: data.isNotEmpty
                              ? data[0].keys.map((key) {
                                  return DataColumn(label: Text(key));
                                }).toList()
                              : [],
                          rows: data.map((row) {
                            return DataRow(
                              cells: row.values.map((value) {
                                return DataCell(Text(value.toString()));
                              }).toList(),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class Page4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page 4')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text('This is Page 4'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final Function onPressed;
  final String label;

  AnimatedButton({required this.onPressed, required this.label});

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
        setState(() {
          _isTapped = true;
        });
      },
      onLongPressEnd: (details) {
        setState(() {
          _isTapped = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _isTapped ? Colors.blue : Colors.transparent,
          border: Border.all(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.all(12),
        child: Text(
          widget.label,
          style: TextStyle(
            color: _isTapped ? Colors.white : Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
