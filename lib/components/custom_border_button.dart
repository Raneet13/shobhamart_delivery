import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class custom_border_button extends StatelessWidget {
  const custom_border_button(
      {super.key,
      required this.title,
      required this.fun,
      required this.icon,
      required this.borderradius,
      required this.bordercolor,
      required this.textstyle,
      required this.bgcolor,
      required this.height,
      required this.width});
  final String title;
  final VoidCallback fun;
  final Icon icon;
  final double borderradius;
  final Color bordercolor;
  final TextStyle textstyle;
  final Color bgcolor;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fun,
      child: Container(
        height: MediaQuery.of(context).size.height * height,
        width: MediaQuery.of(context).size.width * width,
        decoration: BoxDecoration(
          border: Border.all(color: bordercolor, width: 2),
          borderRadius: BorderRadius.circular(borderradius),
          color: bgcolor,
        ),
        // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: textstyle,
            ),
            SizedBox(height: 4),
            // icon
          ],
        ),
      ),
    );
  }
}
