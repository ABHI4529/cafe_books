import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Select_Clip extends StatefulWidget {
  String title;
  bool selected;
  Function callback;
  Select_Clip(
      {Key? key,
      required this.title,
      required this.selected,
      required this.callback})
      : super(key: key);

  @override
  State<Select_Clip> createState() => _Select_ClipState();
}

class _Select_ClipState extends State<Select_Clip> {
  Color textColor = Colors.grey;
  Color backgrounColor = Colors.transparent;
  Color borderColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            backgroundColor: backgrounColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: borderColor, width: 5))),
        onPressed: () {
          if (widget.selected) {
            setState(() {
              textColor = Colors.white;
              backgrounColor = const Color(0xff1A659E);
              borderColor = const Color(0xff0B2C44);
            });
          } else {
            setState(() {
              textColor = Colors.grey;
              backgrounColor = Colors.transparent;
              borderColor = Colors.grey;
            });
          }
        },
        child: Text(
          widget.title,
          style: GoogleFonts.inter(color: textColor),
        ),
      ),
    );
  }
}
