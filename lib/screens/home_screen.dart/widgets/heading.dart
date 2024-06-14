import 'package:flutter/material.dart';

import '../../../components/basic_text.dart';

class heading extends StatelessWidget {
  const heading({
    super.key,
    required this.label,
    required this.icon,
  });
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 30),
        SizedBox(width: 15),
        basic_text(
            title: label,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
