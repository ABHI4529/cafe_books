import 'package:cafe_books/screens/reports/alltransaction.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class DayBook extends StatefulWidget {
  DayBook({Key? key}) : super(key: key);

  @override
  State<DayBook> createState() => _DayBookState();
}

class _DayBookState extends State<DayBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(FontAwesomeIcons.chevronLeft),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Day Book",
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.bold),
          )),
      body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: AllTransaction()),
    );
  }
}
