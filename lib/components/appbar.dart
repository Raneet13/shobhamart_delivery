import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/base_color.dart';

AppBar appbar(BuildContext context, String title, Color color) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    titleSpacing: 0,
    leading: IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: color,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ),
    title: Text(
      title,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: AppColors.primarycolor1,
    ),
  );
}
