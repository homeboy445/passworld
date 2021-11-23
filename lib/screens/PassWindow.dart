import 'package:flutter/material.dart';

class PassWindow extends StatefulWidget {
  @override
  _PassWindowState createState() => _PassWindowState();
}

class _PassWindowState extends State<PassWindow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Column(children: [
        SizedBox(height: 10.0),
        Container(
            margin: EdgeInsets.only(top: 45.0),
            child: Text("It feels so empty.",
                style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold))),
        SizedBox(height: 10.0),
        Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Text(
                "Just press '+' button and get started with adding a password.",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center)),
        SizedBox(height: 40.0),
        Image.asset('assets/images/empty.jpg')
      ]),
    );
  }
}
