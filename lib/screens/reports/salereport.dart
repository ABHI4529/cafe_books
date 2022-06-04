import 'package:cafe_books/screens/sale/sale.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SaleReport extends StatefulWidget {
  SaleReport({Key? key}) : super(key: key);

  @override
  State<SaleReport> createState() => _SaleReportState();
}

class _SaleReportState extends State<SaleReport> {
  DateTime dt = DateTime.now();
  Timestamp tFrom = Timestamp.now();
  Timestamp tTo = Timestamp.now();
  DateFormat dateFormat = DateFormat("dd - MMMM - yyyy");
  @override
  void initState() {
    setState(() {
      tFrom = Timestamp.fromDate(dt.subtract(const Duration(days: 1)));
    });
    super.initState();
  }

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
            "Sale Report",
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.bold),
          )),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date", style: GoogleFonts.inter()),
                TextButton(
                    onPressed: () async {
                      DateTimeRange date = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2001),
                          lastDate: DateTime(2023)) as DateTimeRange;
                      setState(() {
                        tFrom = Timestamp.fromDate(date.start);
                        tTo = Timestamp.fromDate(date.end);
                      });
                    },
                    child: Text(
                      dateFormat.format(dt),
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ))
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: saleCollection
                  .where('date', isGreaterThan: tFrom, isLessThan: tTo)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        "${snapshot.data?.docs[index]['customerName']}",
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
