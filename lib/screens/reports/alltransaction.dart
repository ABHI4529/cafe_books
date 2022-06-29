import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../homepage/homepage.dart';
import 'subreports/ledgerReport/ledger_details.dart';

class AllTransaction extends StatefulWidget {
  AllTransaction({Key? key}) : super(key: key);

  @override
  State<AllTransaction> createState() => _AllTransactionState();
}

class _AllTransactionState extends State<AllTransaction> {
  final allCollection = FirebaseFirestore.instance
      .collection("book_data")
      .doc("${user?.email}")
      .collection('sales');

  DateTime dfrom = DateTime.now();
  DateTime dt = DateTime.now();
  Timestamp tFrom = Timestamp.now();
  Timestamp tTo = Timestamp.now();
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  @override
  void initState() {
    setState(() {
      dt = DateTime(dfrom.year, dfrom.month, dfrom.day);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          child: TextButton(
            onPressed: () async {
              DateTimeRange date = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2001),
                  lastDate: DateTime(2023)) as DateTimeRange;
              setState(() {
                dt = date.start;
                dfrom = date.end;
                tFrom = Timestamp.fromDate(date.start);
                tTo = Timestamp.fromDate(date.end);
              });
            },
            child: Text(
              "${dateFormat.format(dt)} - ${dateFormat.format(dfrom)}",
              style: GoogleFonts.inter(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: allCollection
                .where("date", isGreaterThanOrEqualTo: dt)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text(
                    "No Vouchers",
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ));
                }
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    DateFormat dateFormat = DateFormat("dd - MMMM - yyyy");
                    Timestamp st = snapshot.data!.docs[index]['date'];
                    String date = dateFormat.format(st.toDate());
                    double saleAmount = 0;
                    int voucherNumber = 0;
                    if (snapshot.data?.docs[index]['voucherType'] == "Sale") {
                      saleAmount = snapshot.data?.docs[index]['amountRecevied'];
                      voucherNumber = snapshot.data?.docs[index]['saleNumber'];
                    }
                    if (snapshot.data?.docs[index]['voucherType'] ==
                        "Receipt") {
                      saleAmount = snapshot.data?.docs[index]['receiptAmount'];
                      voucherNumber =
                          snapshot.data?.docs[index]['receiptNumber'];
                    }
                    if (snapshot.data?.docs[index]['voucherType'] ==
                        "Expense") {
                      saleAmount = snapshot.data?.docs[index]['expenseAmount'];
                      voucherNumber =
                          snapshot.data?.docs[index]['voucherNumber'];
                    }

                    return ledgercard(
                        index: index,
                        snapshot: snapshot,
                        voucherNumber: voucherNumber,
                        date: date,
                        voucherType: snapshot.data?.docs[index]['voucherType'],
                        saleAmount: saleAmount);
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}
