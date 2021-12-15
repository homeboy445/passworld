import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:passworld/components/rounded_button.dart';
import 'package:passworld/components/textfield_container.dart';

import '../constants.dart';

class AskPin extends StatefulWidget {
  final authorised;
  final email;
  final authenticate;
  AskPin(this.authorised, this.authenticate, this.email);
  @override
  _AskPinState createState() => _AskPinState();
}

class _AskPinState extends State<AskPin> {
  String pin;
  final storage = new FlutterSecureStorage();

  String getHashedPin() {
    return sha256.convert(utf8.encode(pin)).toString();
  }

  Future<bool> register() async {
    try {
      if (!widget.email.contains('@')) {
        return false;
      }
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: widget.email.trim(), password: getHashedPin());
      await storage.write(key: 'email', value: widget.email.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      print("ERROR!");
      print(e);
    }
    widget.authenticate(false);
    return false;
  }

  Future<bool> signIn() async {
    try {
      if (!widget.email.contains('@')) {
        return false;
      }
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: widget.email, password: getHashedPin());
      return true;
    } on FirebaseAuthException catch (e) {
      print("ERROR!");
      print(e);
    }
    return false;
  }

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
                margin: EdgeInsets.all(20),
                child: Center(
                    child: Text(
                  widget.authorised != null && widget.authorised == true
                      ? "Enter your pin"
                      : "Enter a secure pin.",
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
                  child: Container(
                    margin: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Image.asset(
                        widget.authorised != null && widget.authorised == true
                            ? 'assets/images/pin-code.png'
                            : 'assets/images/askpin.jpg',
                        height: size.height * 0.5),
                  )),
              Container(
                margin: EdgeInsets.only(left: 10.0),
                child: TextFieldContainer(
                    text: "Enter pin(6 digits)",
                    icon: Icon(Icons.lock),
                    function: (val) {
                      pin = val;
                    },
                    isObscure: true,
                    keyboardType: TextInputType.number),
              ),
              RoundedButton(
                  text: "Next",
                  textColor: Colors.white,
                  primaryColor: kButtonColor,
                  function: () async {
                    if (!widget.authorised) {
                      final data = await register();
                      if (!data) {
                        return;
                      }
                      Phoenix.rebirth(context);
                      return;
                    }
                    final status = await signIn();
                    if (!status) {
                      return;
                    }
                    Navigator.pushNamed(context, '/home');
                  }),
              Container(
                  margin: EdgeInsets.all(4.0),
                  child: GestureDetector(
                      onTap: () {},
                      child: (widget.authorised != null &&
                              widget.authorised == true)
                          ? Text("Forgot the pin?",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue))
                          : Text("")))
            ],
          ),
        ),
      ),
    );
  }
}
