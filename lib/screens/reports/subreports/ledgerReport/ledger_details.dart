import 'package:cafe_books/component/ctextfield.dart';
import 'package:cafe_books/screens/homepage/homepage.dart';
import 'package:cafe_books/screens/receipt/editrecipt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import '../../../../datautil/expensedatavoucher.dart';
import '../../../../datautil/saledatahandler.dart';
import '../../../expense/expenseVoucher/editexpensevoucher.dart';
import '../../../sale/editsalevoucher.dart';

class LedgerDetails extends StatefulWidget {
  String? ledger;
  String? ledgerContact;
  double? ledgerClosing;
  LedgerDetails({Key? key, this.ledger, this.ledgerClosing, this.ledgerContact})
      : super(key: key);

  @override
  State<LedgerDetails> createState() => _LedgerDetailsState();
}

class _LedgerDetailsState extends State<LedgerDetails> {
  final ledgerCollection = FirebaseFirestore.instance
      .collection("book_data")
      .doc("${user?.email}")
      .collection('sales');

  @override
  void initState() {
    getAmount();
    super.initState();
  }

  List<double> totalsale = [];

  Future getAmount() async {
    QuerySnapshot querySnapshot = await ledgerCollection
        .where("customerName", isEqualTo: widget.ledger)
        .get();
    final l1 = querySnapshot.docs
        .where((element) => element['voucherType'].toString().contains("Sale"))
        .toList();
    final l2 = querySnapshot.docs
        .where(
            (element) => element['voucherType'].toString().contains("Receipt"))
        .toList();
    for (var element in l1) {
      setState(() {
        totalsale.add(element['amountRecevied']);
      });
    }
    for (var element in l2) {
      setState(() {
        totalsale.add(element['receiptAmount']);
      });
    }
  }

  @override
  void dispose() {
    getAmount();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
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
              "Client Details",
              style: GoogleFonts.inter(color: Colors.black),
            )),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "  ${widget.ledger!}",
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      ),
                      Container(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.call),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.whatsapp),
                                onPressed: () {},
                              )
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: CTextField(
                placeholder: "Search",
                widgetPrefix: Icon(
                  FontAwesomeIcons.filter,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(10),
                child: StreamBuilder(
                  stream: ledgerCollection
                      .where("customerName", isEqualTo: widget.ledger)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        DateFormat dateFormat = DateFormat("dd - MMMM - yyyy");
                        Timestamp st = snapshot.data!.docs[index]['date'];
                        String date = dateFormat.format(st.toDate());
                        double saleAmount = 0;
                        int voucherNumber = 0;
                        if (snapshot.data?.docs[index]['voucherType'] ==
                            "Sale") {
                          saleAmount =
                              snapshot.data?.docs[index]['amountRecevied'];
                          voucherNumber =
                              snapshot.data?.docs[index]['saleNumber'];
                        }
                        if (snapshot.data?.docs[index]['voucherType'] ==
                            "Receipt") {
                          saleAmount =
                              snapshot.data?.docs[index]['receiptAmount'];
                          voucherNumber =
                              snapshot.data?.docs[index]['receiptNumber'];
                        }

                        return ledgercard(
                            index: index,
                            snapshot: snapshot,
                            voucherNumber: voucherNumber,
                            date: date,
                            voucherType: snapshot.data?.docs[index]
                                ['voucherType'],
                            saleAmount: saleAmount);
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total : ₹ ${totalsale.sum}",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Text("Outstanding : ₹ ${widget.ledgerClosing}",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold, fontSize: 17))
                ],
              ),
            )
          ],
        ));
  }
}

class ledgercard extends StatefulWidget {
  ledgercard(
      {Key? key,
      required this.voucherNumber,
      required this.index,
      required this.date,
      required this.saleAmount,
      this.voucherType,
      required this.snapshot})
      : super(key: key);

  final int voucherNumber;
  final String date;
  final double saleAmount;
  String? voucherType;
  int index;
  final AsyncSnapshot<QuerySnapshot> snapshot;

  @override
  State<ledgercard> createState() => _ledgercardState();
}

class _ledgercardState extends State<ledgercard> {
  Color color = Colors.indigo.shade700;
  @override
  void initState() {
    if (widget.voucherType == "Sale") {
      setState(() {
        color = Colors.indigo.shade700;
      });
    }
    if (widget.voucherType == "Expense") {
      setState(() {
        color = Colors.red.shade700;
      });
    }
    if (widget.voucherType == "Receipt") {
      setState(() {
        color = Colors.green.shade700;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.voucherType == "Sale") {
          Timestamp t = widget.snapshot.data?.docs[widget.index]['date'];
          DateTime d = t.toDate();
          List items = widget.snapshot.data!.docs[widget.index]['Items'];

          List<SaleHandler> edititems =
              List<SaleHandler>.from(items.map((e) => SaleHandler.fromJson(e)));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditSale(
                        totalAmountReceived: widget.snapshot.data
                            ?.docs[widget.index]['amountRecevied'],
                        orderNumber: widget.snapshot.data?.docs[widget.index]
                            ['orderNumber'],
                        totaldiscount: widget.snapshot.data?.docs[widget.index]
                            ['discount'],
                        edititems: edititems,
                        customerName: widget.snapshot.data?.docs[widget.index]
                            ['customerName'],
                        docid: widget.snapshot.data?.docs[widget.index].id,
                        value: widget.snapshot.data?.docs[widget.index]
                            ['paymentMethod'],
                        voucherSaleNumber: widget
                            .snapshot.data?.docs[widget.index]['saleNumber'],
                        voucherDate: d,
                        customerContact: widget.snapshot.data
                            ?.docs[widget.index]['customerContact'],
                      )));
        }
        if (widget.voucherType == "Receipt") {
          Timestamp t = widget.snapshot.data?.docs[widget.index]['date'];
          DateTime d = t.toDate();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditReceipt(
                        customerContact: widget.snapshot.data
                            ?.docs[widget.index]['customerContact'],
                        customerName: widget.snapshot.data?.docs[widget.index]
                            ['customerName'],
                        date: d,
                        description: widget.snapshot.data?.docs[widget.index]
                            ['description'],
                        paymentValue: widget.snapshot.data?.docs[widget.index]
                            ['paymentMethod'],
                        receiptNo: widget.snapshot.data?.docs[widget.index]
                            ['receiptNumber'],
                        recAmount: widget.snapshot.data?.docs[widget.index]
                            ['receiptAmount'],
                        voucherId: widget.snapshot.data?.docs[widget.index].id,
                      )));
        }
        if (widget.voucherType == "Expense") {
          Timestamp tm = widget.snapshot.data!.docs[widget.index]['date'];
          DateFormat dt = DateFormat("d - MMMM - yyyy");
          List item = widget.snapshot.data?.docs[widget.index]['items'];
          List<ExpenseItems> itemList = List<ExpenseItems>.from(
              item.map((e) => ExpenseItems.fromJson(e)));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditExpenseVoucer(
                      date: tm.toDate(),
                      list: itemList,
                      id: widget.snapshot.data?.docs[widget.index].id,
                      voucherNumber: widget.snapshot.data?.docs[widget.index]
                          ['voucherNumber'])));
        }
      },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5)
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.snapshot.data?.docs[widget.index]['voucherType']}",
                          style: GoogleFonts.inter(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text("# ${widget.voucherNumber}")
                      ],
                    ),
                    Container(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.date,
                          style: GoogleFonts.inter(color: Colors.black),
                        ),
                        Text(
                          "₹ ${widget.saleAmount}",
                          style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 3,
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    )),
              )
            ],
          )),
    );
  }
}
