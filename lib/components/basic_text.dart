import 'package:flutter/material.dart';

class basic_text extends StatelessWidget {
  const basic_text({
    super.key,
    required this.title,
    required this.style,
  });
  final String title;
  final TextStyle style;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: style,
    );
  }
}
