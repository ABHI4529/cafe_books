import 'package:cafe_books/component/cmenu.dart';
import 'package:cafe_books/component/drawer.dart';
import 'package:cafe_books/screens/reports/alltransaction.dart';
import 'package:cafe_books/screens/reports/salereport.dart';
import 'package:cafe_books/screens/reports/subreports/ledgerReport/ledger_report.dart';
import 'package:cafe_books/screens/sale/sale.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:collection/collection.dart';

import '../../component/selectclip.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

var user = FirebaseAuth.instance.currentUser;

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool page1 = false;
  bool page2 = false;
  bool page3 = false;
  DateTime datetime = DateTime.now();
  DateTime df = DateTime.now();
  Timestamp tfrom = Timestamp.now();
  Timestamp tTo = Timestamp.now();

  @override
  void initState() {
    setState(() {
      tTo = Timestamp.fromDate(DateTime(df.year, df.month, df.day));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xffDCDCDC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "${user?.displayName}",
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu_outlined, color: Colors.black),
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
        drawer: const CDrawer(),
        floatingActionButton: const CMenu(),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SaleCard(tTo: tTo),
                  ),
                  Container(
                    width: 10,
                  ),
                  Expanded(
                      child: StreamBuilder(
                          stream: saleCollection
                              .where('date', isGreaterThanOrEqualTo: tTo)
                              .where("voucherType", isEqualTo: "Expense")
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            List<double> _totalExpense = [];

                            snapshot.data?.docs.forEach((e) {
                              _totalExpense.add(e['expenseAmount']);
                            });
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.grey, blurRadius: 5)
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(FontAwesomeIcons.wallet,
                                            color: Colors.red.shade500),
                                        Text(
                                          "   Expense",
                                          style: GoogleFonts.inter(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        '₹ ${_totalExpense.sum}',
                                        style: GoogleFonts.inter(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          })),
                ],
              ),
              Container(
                height: 20,
              ),
              TabBar(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  indicator: BoxDecoration(
                      color: Colors.indigo.shade800,
                      borderRadius: BorderRadius.circular(8)),
                  unselectedLabelColor: Colors.black87,
                  labelPadding: const EdgeInsets.all(6),
                  tabs: [
                    Text(
                      "Clients",
                      style: GoogleFonts.inter(fontSize: 16),
                    ),
                    Text(
                      "Transactions",
                      style: GoogleFonts.inter(fontSize: 16),
                    )
                  ]),
              Expanded(
                  child: TabBarView(
                children: [LedgerReport(), AllTransaction()],
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class SaleCard extends StatelessWidget {
  const SaleCard({
    Key? key,
    required this.tTo,
  }) : super(key: key);

  final Timestamp tTo;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: saleCollection
            .where('date', isGreaterThanOrEqualTo: tTo)
            .where("voucherType", isEqualTo: "Sale")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<double> _totalSale = [];

          snapshot.data?.docs.forEach((e) {
            _totalSale.add(e['totalSale']);
          });
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SaleReport()));
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(boxShadow: const [
                BoxShadow(color: Colors.grey, blurRadius: 5)
              ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(FontAwesomeIcons.fileContract,
                          color: Colors.blue.shade700),
                      Text(
                        "   Sales",
                        style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      '₹ ${_totalSale.sum}',
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
