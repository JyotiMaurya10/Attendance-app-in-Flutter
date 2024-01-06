import 'package:Miniproject_new/mail.dart';
import 'package:Miniproject_new/take.dart';
import 'package:flutter/material.dart';
import 'defaultersNext.dart';
import 'details.dart';
import 'fetch_attendance.dart';
import 'phpconn.dart'; // Import the Details screen
import 'attendance.dart';
import 'page1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Absence Analyser',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/defaultersNext': (context) => const DefaultersNextScreen(),
        '/details': (context) {
          // Extract arguments
          final Map<String, dynamic>? args = ModalRoute.of(context)
              ?.settings
              .arguments as Map<String, dynamic>?;

          if (args != null) {
            final List list = args['list'];
            final int index = args['index'];

            // Return the Details widget with the extracted arguments
            return Details(list: list, index: index);
          } else {
            // Handle the case where arguments are not provided
            // You might want to show an error screen or redirect to another page
            return const SizedBox(); // Placeholder, replace with appropriate handling
          }
        },
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * 0.45,
            decoration: const BoxDecoration(
              // color: Colors.blue,
              color: Color(0xFFF5CEB8),
              image: DecorationImage(
                alignment: Alignment.centerLeft,
                image: AssetImage("images/bg.png"),
                // fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      alignment: Alignment.center,
                      height: 52,
                      width: 52,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF2BEA1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const Text(
                    "Welcome, \nBack",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                  ),
                  const SizedBox(height: 10),
                  const SearchBar(),
                  const SizedBox(height: 30),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 25,
                      children: <Widget>[
                        CategoryCard(
                          title: "Attendance",
                          image: "images/training.png",
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Take())); //AddColumnScreen()
                          },
                        ),
                        CategoryCard(
                          title: "Defaulters",
                          image: "images/defaultersMP.jpg",
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DefaultersNextScreen()));
                            // Navigator.pushNamed(context, '/defaultersNext');
                          },
                        ),
                        CategoryCard(
                          title: "Details",
                          image: "images/details.png",
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListScreen()));
                            // Navigate to Details screen
                          },
                        ),
                        CategoryCard(
                          title: "Task",
                          image: "images/task.png",
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TaskApp())); //attendance()
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String image;
  final String title;
  final Function press;

  const CategoryCard({
    Key? key,
    required this.image,
    required this.title,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 10),
              blurRadius: 25,
              spreadRadius: 50,
              color: Colors.black87.withOpacity(0.9),
            ),
          ],
        ),
        child: Material(
          child: InkWell(
            onTap: () => press(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  const Spacer(),
                  Image.asset(
                    image,
                    height: 80, // Adjust the height as needed
                  ),
                  const Spacer(),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29.5),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Search",
          icon: Text(
            "🔎",
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }
}
