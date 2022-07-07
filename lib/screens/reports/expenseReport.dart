import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../datautil/expensedatavoucher.dart';
import '../expense/expenseVoucher/editexpensevoucher.dart';
import '../homepage/homepage.dart';

class ExpenseReport extends StatefulWidget {
  ExpenseReport({Key? key}) : super(key: key);

  @override
  State<ExpenseReport> createState() => _ExpenseReportState();
}

class _ExpenseReportState extends State<ExpenseReport> {
  DateTime dfrom = DateTime.now();
  DateTime dt = DateTime.now();
  Timestamp tFrom = Timestamp.now();
  Timestamp tTo = Timestamp.now();
  DateFormat dateFor = DateFormat("dd/MM/yyyy");
  DateFormat dateFormat = DateFormat('d - MMMM - yyyy');
  Future getTotalExpense() async {
    QuerySnapshot expenseData = await _collectionRef
        .where("voucherType", isEqualTo: "Expense")
        .where("date", isGreaterThanOrEqualTo: dt)
        .get();
  }

  final _collectionRef = FirebaseFirestore.instance
      .collection("book_data")
      .doc("${user?.email}")
      .collection("sales");
  @override
  void initState() {
    setState(() {
      dt = DateTime(dfrom.year, dfrom.month);
    });
    super.initState();
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
            "Expense Report",
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.bold),
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: TextButton(
              onPressed: () async {
                DateTimeRange date = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2014),
                    lastDate: DateTime(2023)) as DateTimeRange;
                setState(() {
                  dt = date.start;
                });
              },
              child: Text(
                "${dateFor.format(dt)} - ${dateFor.format(dfrom)}",
                style: GoogleFonts.inter(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _collectionRef
                  .where("voucherType", isEqualTo: "Expense")
                  .where("date", isGreaterThanOrEqualTo: dt)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: snapshot.data!.docs.map((e) {
                      Timestamp tm = e['date'];
                      DateFormat dt = DateFormat("d - MMMM - yyyy");
                      return GestureDetector(
                        onTap: () {
                          List item = e['items'];
                          List<ExpenseItems> itemList = List<ExpenseItems>.from(
                              item.map((e) => ExpenseItems.fromJson(e)));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditExpenseVoucer(
                                      date: tm.toDate(),
                                      list: itemList,
                                      id: e.id,
                                      voucherNumber: e['voucherNumber'])));
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    blurRadius: 5)
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Exp No. # ${e['voucherNumber']}",
                                    style: GoogleFonts.inter(),
                                  ),
                                  Text(
                                    dt.format(tm.toDate()),
                                    style: GoogleFonts.inter(),
                                  )
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: Text(
                                  "₹ ${e['expenseAmount']}",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
