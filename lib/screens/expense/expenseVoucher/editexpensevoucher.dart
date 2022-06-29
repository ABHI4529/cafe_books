import 'package:cafe_books/component/usnackbar.dart';
import 'package:cafe_books/datautil/expensedatavoucher.dart';
import 'package:cafe_books/screens/expense/expenseVoucher/editexpensevoucheritem.dart';
import 'package:cafe_books/screens/expense/expenseVoucher/expenseitem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../../homepage/homepage.dart';

class EditExpenseVoucer extends StatefulWidget {
  DateTime date;
  int? voucherNumber;
  String? id;
  List<ExpenseItems>? list;
  EditExpenseVoucer(
      {Key? key, required this.date, this.voucherNumber, this.list, this.id})
      : super(key: key);

  @override
  State<EditExpenseVoucer> createState() => _ExpenseVoucerState();
}

class _ExpenseVoucerState extends State<EditExpenseVoucer> {
  final dateFormat = DateFormat("dd - MMMM - yyyy");
  DateTime _dateTime = DateTime.now();
  String _date = "";
  double _totalAmount = 0;
  @override
  void initState() {
    setState(() {
      _date = dateFormat.format(widget.date);
      expenseVoucherList = widget.list!;
      expenseNumber = widget.voucherNumber!;
    });
    updateTotal();
    super.initState();
  }

  int expenseNumber = 1;
  final _expCollection = FirebaseFirestore.instance
      .collection('book_data')
      .doc("${user?.email}")
      .collection("sales");

  Future updateExpenseNumber() async {
    QuerySnapshot _expenseNumber = await _expCollection
        .where("voucherType", isEqualTo: "Expense")
        .orderBy("voucherNumber")
        .get();
    setState(() {
      expenseNumber = _expenseNumber.docs.length + 1;
    });
  }

  Future saveData() async {
    _expCollection.doc(widget.id).update({
      "voucherType": "Expense",
      "date": _dateTime,
      "expenseAmount": totalAmount,
      "voucherNumber": expenseNumber,
      "items": expenseVoucherList.map((e) => e.toJson()).toList()
    });
  }

  double totalAmount = 0;
  Future updateTotal() async {
    List<double> _total = [];
    if (expenseVoucherList.isEmpty) {
      setState(() {
        totalAmount = 0;
      });
    } else {
      for (var e in expenseVoucherList) {
        setState(() {
          _total.add(e.amount!);
        });
      }
      setState(() {
        totalAmount = _total.sum;
      });
    }
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
            "Expenses",
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.bold),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 10)
              ]),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      final selectdate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2022, 4, 1),
                          lastDate: DateTime(2023, 4, 1));

                      if (selectdate.toString().isEmpty) {
                        setState(() {
                          _date = dateFormat.format(DateTime.now());
                          _dateTime = DateTime.now();
                        });
                      } else {
                        setState(() {
                          _date = dateFormat.format(selectdate!);
                          _dateTime = selectdate;
                        });
                      }
                    },
                    child: Text(
                      _date,
                      style: GoogleFonts.inter(color: Colors.black),
                    ),
                  ),
                  Text(
                    "Expense No : $expenseNumber",
                    style: GoogleFonts.inter(),
                  )
                ],
              ),
            ),
            Column(
              children: expenseVoucherList.map((e) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoModalPopupRoute(
                            builder: (context) => EditVoucherExpenseItem(
                                  refresh: () {
                                    setState(() {
                                      updateTotal();
                                    });
                                  },
                                  itemName: e.itemName,
                                  index: expenseVoucherList.indexOf(e),
                                  quantity: e.quantity,
                                  amount: e.amount,
                                  price: e.price,
                                  description: e.description,
                                )));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.indigo.shade700.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            "# ${expenseVoucherList.indexOf(e) + 1}",
                            style: GoogleFonts.inter(
                                fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${e.itemName}",
                              style: GoogleFonts.inter(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₹ ${e.amount}",
                              style: GoogleFonts.inter(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Subtotal = Quantity x Price",
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${e.quantity} x ₹ ${e.price} = ₹ ${e.amount}",
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: GoogleFonts.inter(fontSize: 20),
                  ),
                  Text(
                    "₹ $totalAmount",
                    style: GoogleFonts.inter(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: OutlinedButton(
                  onPressed: () {
                    updateTotal();
                    Navigator.push(
                        context,
                        CupertinoModalPopupRoute(
                          builder: (context) => VoucherExpenseItem(
                            refresh: () {
                              setState(() {
                                updateTotal();
                              });
                            },
                          ),
                        ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Add  ",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo.shade700)),
                      Icon(
                        Icons.add_circle,
                        color: Colors.indigo.shade700,
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Container(
          height: 60,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 10)
          ]),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: TextButton(
                    child: Text(
                      "Delete",
                      style: GoogleFonts.inter(),
                    ),
                    onPressed: () {
                      saveData().then((value) async {
                        await _expCollection
                            .doc(widget.id)
                            .delete()
                            .then((value) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                              USnackbar(message: "Voucher Deleted"));
                        });
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        primary: Colors.indigo.shade700),
                    child: Text(
                      "Save",
                      style: GoogleFonts.inter(),
                    ),
                    onPressed: () {
                      saveData().then((value) {
                        setState(() {
                          expenseVoucherList.clear();
                        });
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
