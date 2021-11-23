import 'package:flutter/material.dart';
import 'package:passworld/components/rounded_button.dart';
import 'package:passworld/components/textfield_container.dart';

import '../constants.dart';

class AskPin extends StatefulWidget {
  const AskPin({Key key, @required this.size, @required this.update})
      : super(key: key);

  final Size size;
  final Function update;

  @override
  _AskPinState createState() => _AskPinState();
}

class _AskPinState extends State<AskPin> {
  String email;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 30.0),
        child: Column(
          children: [
            Center(
                child: Text("Passworld.",
                    style: TextStyle(fontSize: 60, fontFamily: 'Pacifico'))),
            Container(
              margin: EdgeInsets.all(20),
              child: Center(
                  child: Text(
                "Enter a secure pin.",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              )),
            ),
            Positioned(
                top: 0,
                left: 0,
                child: Image.asset('assets/images/askpin.jpg',
                    height: widget.size.height * 0.5)),
            Container(
              margin: EdgeInsets.only(left: 10.0),
              child: TextFieldContainer(
                  text: "Enter pin",
                  icon: Icon(Icons.lock),
                  function: (val) {
                    email = val;
                  },
                  isObscure: false),
            ),
            RoundedButton(
                text: "Next",
                textColor: Colors.white,
                primaryColor: kButtonColor,
                function: () {
                  widget.update();
                }),
          ],
        ),
      ),
    );
  }
}
