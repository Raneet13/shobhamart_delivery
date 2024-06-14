// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../core/theme/base_color.dart';

class dialogue_box extends StatelessWidget {
  final String message;
  final String button1Text;
  final String button2Text;
  final Function() onButton1Pressed;
  final Function() onButton2Pressed;

  dialogue_box(
      {required this.message,
      required this.button1Text,
      required this.button2Text,
      required this.onButton1Pressed,
      required this.onButton2Pressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.black,
                      )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: onButton1Pressed,
                  child: Text(
                    button1Text,
                    style: TextStyle(color: AppColors.primarycolor2),
                  ),
                ),
                TextButton(
                  onPressed: onButton2Pressed,
                  child: Text(
                    button1Text,
                    style: TextStyle(color: AppColors.primarycolor2),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
