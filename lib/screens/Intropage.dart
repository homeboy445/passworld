import 'package:flutter/material.dart';
import 'package:passworld/components/rounded_button.dart';
import 'package:passworld/components/textfield_container.dart';
import 'package:passworld/screens/AskPin.dart';

import '../constants.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  String email;

  get authenticate => null;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 30.0),
          child: Column(
            children: [
              Center(
                  child: Text("Passworld.",
                      style: TextStyle(fontSize: 60, fontFamily: 'Pacifico'))),
              Container(
                margin: EdgeInsets.all(15),
                child: Center(
                    child: Text(
                  "Never worry about your passwords, ever again.",
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                )),
              ),
              Positioned(
                  top: 0,
                  left: 0,
                  child: Image.asset('assets/images/confused.jpg',
                      height: size.height * 0.5)),
              Container(
                margin: EdgeInsets.only(left: 10.0),
                child: TextFieldContainer(
                    text: "Enter your email",
                    icon: Icon(Icons.email),
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
                    //TODO: Add a check for existing user.
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AskPin(false, authenticate, email)));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
