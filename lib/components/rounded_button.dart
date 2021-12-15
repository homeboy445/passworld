import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Color primaryColor, textColor;
  final Function function;

  RoundedButton(
      {@required this.text,
      @required this.primaryColor,
      @required this.textColor,
      @required this.function});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.065,
        width: size.width * 0.85,
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              )),
              backgroundColor: MaterialStateProperty.all(primaryColor),
            ),
            onPressed: () {
              function();
            },
            child: Text(text,
                style: TextStyle(
                    color: textColor, fontSize: 25.0, fontFamily: 'Poppins'))));
  }
}
