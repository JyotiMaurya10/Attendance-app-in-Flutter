import 'package:flutter/material.dart';
import 'fetch_attendance.dart';

class DefaultersNextScreen extends StatelessWidget {
  const DefaultersNextScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: const Icon(Icons.account_box_sharp),
        title: const Text(
          "Absence Analyser",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(color: Colors.black, blurRadius: 4.0, offset: Offset(2, 2))
            ],
          ),
        ),
        actions: const [Icon(Icons.more_vert)],
        elevation: 15,
        shadowColor: Colors.black87,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueAccent, Colors.purpleAccent],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                padding: const EdgeInsets.all(40),
                child: GridView(
                  padding: const EdgeInsets.all(30),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 50,
                    crossAxisSpacing: 40,
                  ),
                  children: [
                    buildGridItem(context, 'images/list.png', 'List'),
                    // buildGridItem(context, 'images/Actions.png', 'Actions'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridItem(BuildContext context, String imagePath, String title) {
    return Material(
      color: Colors.blue,
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        splashColor: Colors.black26,
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => FetchAttendance())),
        // Navigator.pushNamed(context, '/details'),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.blue, width: 3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Ink.image(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
