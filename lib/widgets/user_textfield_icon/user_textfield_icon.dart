import 'package:Utician/util/util.dart';
import 'package:Utician/util/validator.dart';
import 'package:flutter/material.dart';

class UserTextFieldIcon extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final Color baseColor;
  final Color borderColor;
  final Color errorColor;
  final TextInputType inputType;
  final bool obscureText;
  final Function validator;
  final Function onChanged;
  final Icon icon;
  final String errorCode;

  UserTextFieldIcon(
      {this.hint,
      this.controller,
      this.onChanged,
      this.baseColor,
      this.borderColor,
      this.errorColor,
      this.inputType = TextInputType.text,
      this.obscureText = false,
      this.validator,
      this.icon,
      this.errorCode });

  _UserTextFieldIconState createState() => _UserTextFieldIconState();
}

class _UserTextFieldIconState extends State<UserTextFieldIcon> {
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
        child: TextFormField(
          validator: (value) {
              if (value.isEmpty) {
                return Util.empty_username;
              }
              return null;
            },
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
          autofocus: true,
          decoration: InputDecoration(
            hintStyle: TextStyle(
              color: widget.baseColor,
              fontFamily: Util.BemeLight,
              fontWeight: FontWeight.w300,
            ),
            
            hintText: widget.hint,
            icon: Icon(Icons.people),  
            errorText: widget.errorCode,
            
            //prefixIcon: Icon(Icons.lock_outline)
          ),
        ),
      ),
    );
  }
}