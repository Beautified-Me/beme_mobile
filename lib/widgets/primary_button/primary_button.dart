import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final TextStyle buttonTextStyle;
  final String buttonName;
  final Color buttonColor;
  final Color highlightColor;

  PrimaryButton(
      {this.buttonName,
      this.onPressed,
      this.buttonTextStyle,
      this.highlightColor,
      this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return new Container(
        width: 150.0,
        child: new MaterialButton(
            child: new Text(buttonName,
                textDirection: TextDirection.ltr, style: buttonTextStyle),
            // shape: new RoundedRectangleBorder(
            //     borderRadius: new BorderRadius.circular(4.0)),
            color: buttonColor,
            highlightColor: highlightColor,
            onPressed: onPressed));
  }
}