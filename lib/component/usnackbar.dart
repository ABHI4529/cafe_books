import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class USnackbar extends SnackBar {
  String message;
  Color? color;
  USnackbar({Key? key, this.color, required this.message})
      : super(
            key: key,
            content: Text(
              message,
              style: GoogleFonts.inter(color: Colors.white),
            ),
            backgroundColor: color);
}
