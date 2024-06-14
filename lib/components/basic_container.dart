// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../core/theme/base_color.dart';

class basic_container extends StatelessWidget {
  const basic_container(
      {super.key,
      required this.child,
      required this.height,
      required this.iscatagory});
  final Widget child;
  final double height;
  final bool iscatagory;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Container(
            padding: EdgeInsets.all(4),
            width: iscatagory == true
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width * 0.94,
            height: height * height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: AppColors.white1,
            ),
            child: child),
      ),
    );
  }
}
