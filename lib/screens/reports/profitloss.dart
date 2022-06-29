// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:cafe_books/screens/sale/sale.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import '../../datautil/expensedatavoucher.dart';
import '../expense/expenseVoucher/editexpensevoucher.dart';
import '../homepage/homepage.dart';

class ProfitLoss extends StatefulWidget {
  ProfitLoss({Key? key}) : super(key: key);

  @override
  State<ProfitLoss> createState() => _ProfitLossState();
}

class _ProfitLossState extends State<ProfitLoss> {
  double _totalProfit = 0;
  var allCollection = FirebaseFirestore.instance
      .collection("book_data")
      .doc("${user?.email}")
      .collection('sales');
  var stockCollection = FirebaseFirestore.instance
      .collection("book_data")
      .doc("${user?.email}")
      .collection('stockTranscation');

  @override
  void initState() {
    getProft();
    super.initState();
  }

  Future getProft() async {
    QuerySnapshot saleData =
        await allCollection.where("voucherType", isEqualTo: "Sale").get();
    QuerySnapshot expenseData =
        await allCollection.where("voucherType", isEqualTo: "Expense").get();
    QuerySnapshot stockData =
        await stockCollection.where("purchase", isEqualTo: true).get();
    List<double> _totalSale = [];
    List<double> _totalExpense = [];
    List<double> _totalStock = [];
    saleData.docs.forEach((e) {
      _totalSale.add(e['totalSale']);
    });
    expenseData.docs.forEach((e) {
      _totalExpense.add(e['expenseAmount']);
    });
    stockData.docs.forEach((e) {
      _totalStock.add(e['total']);
    });
    setState(() {
      _totalProfit = _totalSale.sum - (_totalExpense.sum + _totalStock.sum);
    });
  }

  DateTime dfrom = DateTime.now();
  DateTime dt = DateTime.now();
  Timestamp tFrom = Timestamp.now();
  Timestamp tTo = Timestamp.now();
  DateFormat dateFor = DateFormat("dd/MM/yyyy");
  DateFormat dateFormat = DateFormat('d - MMMM - yyyy');
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
            "Profit & Loss",
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.bold),
          )),
      body: SingleChildScrollView(
          child: Column(
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
                "${dateFor.format(dt)} - ${dateFor.format(dfrom)}",
                style: GoogleFonts.inter(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SaleCard(),
          const ExpenseCard(),
          StockCard(stockCollection: stockCollection, dateFormat: dateFormat)
        ],
      )),
      bottomSheet: BottomAppBar(
        child: Container(
          height: 60,
          width: double.maxFinite,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 5)
          ]),
          child: Text(
            "Total Profit :  ₹ $_totalProfit",
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> SaleCard() {
    return StreamBuilder(
        stream:
            saleCollection.where("voucherType", isEqualTo: "Sale").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<double> _totalsale = [];
            for (var e in snapshot.data!.docs) {
              _totalsale.add(e['totalSale']);
            }
            return ExpansionTile(
                title: Text(
                  "Total Sale",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  "₹ ${_totalsale.sum}",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
                children: snapshot.data!.docs.map((e) {
                  Timestamp tm = e['date'];
                  DateTime dt = tm.toDate();
                  return Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 3)
                          ]),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Sale No. # ${e['saleNumber']}",
                                style: GoogleFonts.inter(),
                              ),
                              Text(
                                dateFormat.format(dt),
                                style: GoogleFonts.inter(),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "${e['customerName']}",
                                  style: GoogleFonts.inter(),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "₹ ${e['totalSale']}",
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          )
                        ],
                      ));
                }).toList());
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}

class StockCard extends StatelessWidget {
  const StockCard({
    Key? key,
    required this.stockCollection,
    required this.dateFormat,
  }) : super(key: key);

  final CollectionReference<Map<String, dynamic>> stockCollection;
  final DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: stockCollection.where("purchase", isEqualTo: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<double> _totalsale = [];
            for (var e in snapshot.data!.docs) {
              _totalsale.add(e['total']);
            }
            return ExpansionTile(
              title: Text(
                "Stock Purchases",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                "₹ ${_totalsale.sum}",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
              children: snapshot.data!.docs.map((e) {
                Timestamp tm = e['stockDate'];
                DateTime dt = tm.toDate();
                return Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.4), blurRadius: 3)
                      ]),
                  padding: const EdgeInsets.all(10),
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Stock No. # ${e['stockTrn']}",
                            style: GoogleFonts.inter(),
                          ),
                          Text(
                            dateFormat.format(dt),
                            style: GoogleFonts.inter(),
                          )
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "₹ ${e['total']}",
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: saleCollection
            .where("voucherType", isEqualTo: "Expense")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<double> _totalsale = [];
            for (var e in snapshot.data!.docs) {
              _totalsale.add(e['expenseAmount']);
            }
            return ExpansionTile(
              title: Text(
                "Total Expenses",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                "₹ ${_totalsale.sum}",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
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
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        });
  }
}
