import 'package:flutter/material.dart';

import '../core/theme/base_color.dart';

class text_box extends StatelessWidget {
  const text_box(
      {super.key,
      required this.value,
      required this.title,
      required this.hint,
      this.height,
      required this.obsureText,
      this.validator,
      this.keyboard});

  final TextEditingController value;
  final String title;
  final String hint;
  final double? height;
  final bool obsureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboard;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 1),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white),
          child: TextFormField(
            maxLines: 1,
            keyboardType: keyboard,
            style:
                TextStyle(fontFamily: 'Roboto', color: AppColors.primarycolor1),
            controller: value,
            validator: validator,
            obscureText: obsureText,
            obscuringCharacter: '*',
            decoration: InputDecoration(
                hintText: hint,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                )),
          ),
        ),
      ],
    );
  }
}
