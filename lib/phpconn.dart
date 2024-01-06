import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'details.dart';

class ListScreen extends StatefulWidget {
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  Future<List> getData() async {
    final response = await http
        .get(Uri.parse("http://192.168.241.42/miniproject/getdata.php"));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Detail"),
      ),
      body: FutureBuilder<List>(
        future: getData(),
        builder: (ctx, ss) {
          if (ss.hasError) {
            print("Error");
            return Text('Error: ${ss.error}');
          }
          if (ss.hasData) {
            return Items(list: ss.data!);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class Items extends StatelessWidget {
  final List list;

  Items({required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list?.length ?? 0,
      //list == null ? 0 : list.length,
      itemBuilder: (ctx, i) {
        return Column(
          children: [
            Divider(
              height: 1,
              color: Colors.blue,
            ),
            ListTile(
              minVerticalPadding: 40,
              leading: CircleAvatar(
                child: Text(list[i]['roll_no']
                    .toString()), // Display roll number in a circle avatar
              ),

              //const Icon(Icons.perm_identity_rounded),
              title: Text('${list[i]['name_of_student']}'), // Display name
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '📞 : ${list[i]['mobile_number']}'), // Display mobile number
                  Text('📧 : ${list[i]['email']}'), // Display email
                  Text('🏡 : ${list[i]['address']}'), // Display address
                ],
              ),

              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/details',
                  arguments: {'list': list, 'index': i},
                );
              },
            ),
          ],
        );
      },
    );
  }
}
