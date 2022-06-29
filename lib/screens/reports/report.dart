import 'package:cafe_books/screens/reports/profitloss.dart';
import 'package:cafe_books/screens/reports/salereport.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'daybook.dart';

class Report extends StatefulWidget {
  Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            "Reports",
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.bold),
          )),
      body: ListView(
        children: [
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SaleReport()));
            },
            title: Text(
              "Sale Report",
              style: GoogleFonts.inter(),
            ),
            trailing: const Icon(FontAwesomeIcons.chartLine),
          ),
          ListTile(
            title: Text(
              "Stock Report",
              style: GoogleFonts.inter(),
            ),
            trailing: const Icon(FontAwesomeIcons.boxOpen),
          ),
          ListTile(
            title: Text(
              "Receipt Report",
              style: GoogleFonts.inter(),
            ),
            trailing: const Icon(FontAwesomeIcons.fileWaveform),
          ),
          ListTile(
            title: Text(
              "Expense Report",
              style: GoogleFonts.inter(),
            ),
            trailing: const Icon(FontAwesomeIcons.wallet),
          ),
          ListTile(
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfitLoss()))
            },
            title: Text(
              "Profit & Loss",
              style: GoogleFonts.inter(),
            ),
            trailing: const Icon(FontAwesomeIcons.fileInvoice),
          ),
          ListTile(
            onTap: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => DayBook()))
            },
            title: Text(
              "Day Book",
              style: GoogleFonts.inter(),
            ),
            trailing: const Icon(FontAwesomeIcons.calendarDay),
          )
        ],
      ),
    );
  }
}
