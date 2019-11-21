import 'package:Utician/util/util.dart';
import 'package:flutter/material.dart';

class PasswordTextFieldIcon extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final Color baseColor;
  final Color borderColor;
  final Color errorColor;
  final TextInputType inputType;
  bool obscureText;
  final Function validator;
  final Function onChanged;
  final Icon icon;

  PasswordTextFieldIcon(
      {this.hint,
      this.controller,
      this.onChanged,
      this.baseColor,
      this.borderColor,
      this.errorColor,
      this.inputType = TextInputType.text,
      this.obscureText = false,
      this.validator,
      this.icon });

  _PasswordTextFieldIconState createState() => _PasswordTextFieldIconState();
}

class _PasswordTextFieldIconState extends State<PasswordTextFieldIcon> {
  Color currentColor;

  @override
  void initState() {
    super.initState();
    currentColor = widget.borderColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: TextField(
          obscureText: widget.obscureText,
          onChanged: (text) {
            if (widget.onChanged != null) {
              widget.onChanged(text);
            }
            setState(() {
              if (!widget.validator(text) || text.length == 0) {
                currentColor = widget.errorColor;
              } else {
                currentColor = widget.baseColor;
              }
            });
          }, 
          //keyboardType: widget.inputType,
          controller: widget.controller,
          decoration: InputDecoration(
            hintStyle: TextStyle(
              color: widget.baseColor,
              fontFamily: Util.BemeLight,
              fontWeight: FontWeight.w300,
            ),
            
            hintText: widget.hint,
            icon: Icon(Icons.lock_outline),
            suffixIcon: new GestureDetector(
             onTap: () {
              setState(() {
                widget.obscureText = !widget.obscureText;
              });
            },
          child: Icon(widget.obscureText ? Icons.visibility : Icons.visibility_off),
            
          ),
        ),
      ),
    )
    );
  }
}