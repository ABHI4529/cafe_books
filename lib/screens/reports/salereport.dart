import 'package:cafe_books/screens/sale/sale.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import '../homepage/homepage.dart';

class SaleReport extends StatefulWidget {
  SaleReport({Key? key}) : super(key: key);

  @override
  State<SaleReport> createState() => _SaleReportState();
}

class _SaleReportState extends State<SaleReport> {
  DateTime dt = DateTime.now();
  DateTime df = DateTime.now();
  Timestamp tFrom = Timestamp.now();
  Timestamp tTo = Timestamp.now();
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  final saleRef = FirebaseFirestore.instance
      .collection("book_data")
      .doc("${user?.email}")
      .collection("sales")
      .where("voucherType", isEqualTo: "Sale");
  @override
  void initState() {
    setState(() {
      dt = DateTime(df.year, df.month, df.day);
    });
    getTotal();
    super.initState();
  }

  double total = 0;

  Future getTotal() async {
    List<double> totallist = [];
    QuerySnapshot querySnapshot =
        await saleRef.where('date', isGreaterThanOrEqualTo: dt).get();

    querySnapshot.docs.forEach((e) {
      totallist.add(e['totalSale']);
    });
    setState(() {
      total = totallist.sum;
    });
  }

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
            "Sale Report",
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.bold),
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: TextButton(
                onPressed: () async {
                  DateTimeRange date = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2001),
                      lastDate: DateTime(2023)) as DateTimeRange;
                  setState(() {
                    dt = date.start;
                    df = date.end;
                    tFrom = Timestamp.fromDate(date.start);
                    tTo = Timestamp.fromDate(date.end);
                  });
                  getTotal();
                },
                child: Text(
                  "${dateFormat.format(df)} - ${dateFormat.format(dt)}",
                  style: GoogleFonts.inter(color: Colors.indigo.shade700),
                )),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  saleRef.where('date', isGreaterThanOrEqualTo: dt).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No data in the current date",
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  return Container(
                    width: double.maxFinite,
                    child: DataTable(
                        dividerThickness: 2,
                        dataRowHeight: 40,
                        headingRowHeight: 40,
                        columnSpacing: 0,
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Colors.indigo.shade700),
                        columns: [
                          DataColumn(
                              label: Text(
                            "Inv",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                          DataColumn(
                              label: Text(
                            "Date",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                          DataColumn(
                              label: SizedBox(
                            width: 150,
                            child: Text(
                              "Name",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                          DataColumn(
                              label: Text(
                            "Amount",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                        ],
                        rows: snapshot.data!.docs.map((e) {
                          Timestamp tt = e['date'];
                          DateTime dd = tt.toDate();
                          return DataRow(cells: [
                            DataCell(Text("# ${e['saleNumber']}")),
                            DataCell(Text(dateFormat.format(dd))),
                            DataCell(Text("${e['customerName']}")),
                            DataCell(Text("₹ ${e['totalSale']}")),
                          ]);
                        }).toList()),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerRight,
            child: Text(
              "Total : ₹ $total",
              style:
                  GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
