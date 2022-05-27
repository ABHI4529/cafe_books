import 'dart:ffi';

import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CMenu extends StatefulWidget {
  const CMenu({Key? key}) : super(key: key);

  @override
  State<CMenu> createState() => _CMenuState();
}

class _CMenuState extends State<CMenu> with TickerProviderStateMixin {
  var icon = Icon(Icons.add, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return FabCircularMenu(
      onDisplayChange: (val) {
        if (val) {
          setState(() {
            icon = Icon(Icons.close, color: Colors.white);
          });
        } else {
          setState(() {
            icon = Icon(Icons.add, color: Colors.white);
          });
        }
      },
      fabColor: Colors.blue.shade700,
      ringColor: Colors.blue.shade700,
      fabChild: icon,
      children: [
        TextButton(
          onPressed: () {},
          child: Text("Sale",
              style: GoogleFonts.inter(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "Expense",
            style: GoogleFonts.inter(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "Purchase",
            style: GoogleFonts.inter(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "Clients",
            style: GoogleFonts.inter(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "Items",
            style: GoogleFonts.inter(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
