import 'package:flutter/material.dart';
import 'package:passworld/screens/AskPin.dart';
import 'package:passworld/screens/Intropage.dart';
import 'package:passworld/screens/PassWindow.dart';

void main() {
  runApp(MaterialApp(
    home: Passworld(),
    theme: ThemeData(
      backgroundColor: Color(0xFFFFFFFF),
      primaryColor: Colors.purple,
    ),
    debugShowCheckedModeBanner: false,
  ));
}

class Passworld extends StatefulWidget {
  @override
  _PassworldState createState() => _PassworldState();
}

class _PassworldState extends State<Passworld> {
  int window = 0;
  void changeState() {
    setState(() {
      window = (window + 1) % 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Add Password',
          child: Icon(Icons.add),
        ),
        body: window == 0
            ? IntroPage(size: size, update: changeState)
            : window == 1
                ? AskPin(size: size, update: changeState)
                : PassWindow());
  }
}
