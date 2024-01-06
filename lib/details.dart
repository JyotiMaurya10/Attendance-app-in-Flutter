import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final List list;
  final int index;

  Details({required this.list, required this.index});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late String name;
  late String mobile;

  @override
  void initState() {
    super.initState();

    // Access data and perform any necessary initialization after initState
    name = widget.list[widget.index]['name_of_student'];
    mobile = widget.list[widget.index]['mobile_number'];
  }

  void confirm() {
    // Implement your confirmation logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              name,
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(mobile),
            ElevatedButton(
              onPressed: () {
                // Implement your edit logic here
              },
              child: const Text("Edit"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => confirm(),
              child: const Text("Delete"),
            ),
          ],
        ),
      ),
    );
  }
}
