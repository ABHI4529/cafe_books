import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CTextField extends StatelessWidget {
  String? placeholder;
  TextInputType? textInputType;
  TextEditingController? controller;
  CTextField({Key? key, this.placeholder, this.controller, this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: CupertinoTextField(
        keyboardType: textInputType,
        controller: controller,
        padding: const EdgeInsets.all(10),
        placeholder: placeholder,
      ),
    );
  }
}
