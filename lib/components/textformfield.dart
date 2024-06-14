// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class textformfield extends StatefulWidget {
  const textformfield(
      {super.key,
      required this.label,
      this.obscureText,
      required this.controller,
      this.validator});
  final String label;
  final bool? obscureText;
  final TextEditingController controller;
  final String? validator;

  @override
  State<textformfield> createState() => _textformfieldState();
}

class _textformfieldState extends State<textformfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.controller,
        validator: (value) => widget.validator,
        obscureText: widget.label == 'Password' ? true : false,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(color: Colors.black87),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black87),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black87),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black87),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black87),
          ),
        ));
  }
}
