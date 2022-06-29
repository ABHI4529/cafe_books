import 'package:cafe_books/screens/homepage/homepage.dart';
import 'package:cafe_books/screens/reports/subreports/ledgerReport/ledger_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LedgerReport extends StatefulWidget {
  LedgerReport({Key? key}) : super(key: key);

  @override
  State<LedgerReport> createState() => _LedgerReportState();
}

String universalClientId = "";

class _LedgerReportState extends State<LedgerReport> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("book_data")
          .doc("${user?.email}")
          .collection("clients")
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: snapshot.data?.docs.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                setState(() {
                  universalClientId = "${snapshot.data?.docs[index].id}";
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LedgerDetails(
                              ledger:
                                  "${snapshot.data?.docs[index]['clientName']}",
                              ledgerClosing: snapshot.data?.docs[index]
                                  ['closing'],
                              ledgerContact:
                                  "${snapshot.data?.docs[index]['clientContact']}",
                            )));
              },
              title: Text(
                "${snapshot.data?.docs[index]['clientName']}",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                "₹ ${snapshot.data?.docs[index]['closing']}",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
            );
          },
        );
      },
    );
  }
}
