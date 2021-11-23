import 'package:flutter/material.dart';
import '../constants.dart';

class TextFieldContainer extends StatelessWidget {
  final String text;
  final Icon icon;
  final bool isObscure;
  final Function function;

  TextFieldContainer(
      {@required this.text,
      @required this.icon,
      this.isObscure,
      @required this.function});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: kPrimaryLightColor),
        width: size.width * 0.85,
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: TextField(
          onChanged: (value) {
            function(value);
          },
          obscureText: isObscure,
          decoration: InputDecoration(
              icon: icon, hintText: text, border: InputBorder.none),
        ));
  }
}
