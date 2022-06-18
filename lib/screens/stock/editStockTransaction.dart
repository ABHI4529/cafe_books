import 'package:cafe_books/datautil/stockvoucherdata.dart';
import 'package:cafe_books/screens/homepage/homepage.dart';
import 'package:cafe_books/screens/stock/voucherstock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class EditStockTransaction extends StatefulWidget {
  List<StockItem>? itemList;
  String? trnID;
  int? trnNo;
  bool? isPurchase;
  EditStockTransaction(
      {Key? key, this.itemList, this.trnID, this.trnNo, this.isPurchase})
      : super(key: key);

  @override
  State<EditStockTransaction> createState() => _EditStockTransactionState();
}

class _EditStockTransactionState extends State<EditStockTransaction> {
  bool isSelected = false;
  final dateFormat = DateFormat("dd - MMMM - yyyy");
  DateTime _dateTime = DateTime.now();
  String _date = "";
  double _totalAmount = 0;
  @override
  void initState() {
    setState(() {
      _date = dateFormat.format(_dateTime);
      stockVoucherItems = widget.itemList!;
      isSelected = widget.isPurchase!;
      transactionNumber = widget.trnNo!;
      updateTotal();
    });
    super.initState();
  }

  final PageController _pageController = PageController(initialPage: 1);

  Future deleteTransaction() async {
    final stockTrnRef = FirebaseFirestore.instance
        .collection("book_data")
        .doc("${user?.email}")
        .collection("stockTranscation");

    stockTrnRef.doc(widget.trnID).delete();
  }

  Future saveTransaction() async {
    final stockTrnRef = FirebaseFirestore.instance
        .collection("book_data")
        .doc("${user?.email}")
        .collection("stockTranscation");

    if (isSelected) {
      stockTrnRef.doc(widget.trnID).update({
        "stockDate": _dateTime,
        "stockItems": stockVoucherItems.map((e) => e.toJson()).toList(),
        "total": _totalAmount,
        "purchase": true,
        "stockTrn": transactionNumber
      });
    } else {
      stockTrnRef.doc(widget.trnID).update({
        "stockDate": _dateTime,
        "stockItems": stockVoucherItems.map((e) => e.toJson()).toList(),
        "total": _totalAmount,
        "purchase": false,
        "stockTrn": transactionNumber
      });
    }
  }

  Future removeStock() async {
    final stockRef = FirebaseFirestore.instance
        .collection("book_data")
        .doc("${user?.email}")
        .collection("stock");
    stockVoucherItems.forEach((element) async {
      final QuerySnapshot query =
          await stockRef.where("itemName", isEqualTo: element.itemName).get();
      stockRef.doc(element.docID).update(
          {"stockItemClosing": element.currentStock! - element.itemQuantity});
    });
  }

  Future addRemoveStock() async {
    final stockRef = FirebaseFirestore.instance
        .collection("book_data")
        .doc("${user?.email}")
        .collection("stock");

    if (isSelected) {
      stockVoucherItems.forEach((element) async {
        final QuerySnapshot query =
            await stockRef.where("itemName", isEqualTo: element.itemName).get();
        stockRef.doc(element.docID).update(
            {"stockItemClosing": element.currentStock! + element.itemQuantity});
      });
    } else {
      stockVoucherItems.forEach((element) async {
        final QuerySnapshot query =
            await stockRef.where("itemName", isEqualTo: element.itemName).get();
        stockRef.doc(element.docID).update(
            {"stockItemClosing": element.currentStock! - element.itemQuantity});
      });
    }
  }

  int transactionNumber = 0;

  Future updateStockNumber() async {
    final stockTrnRef = FirebaseFirestore.instance
        .collection("book_data")
        .doc("${user?.email}")
        .collection("stockTranscation");

    final stockTrn = await stockTrnRef.get();
    setState(() {
      transactionNumber = stockTrn.docs.length + 1;
    });
  }

  Future updateTotal() async {
    List<double> _totalList = [];
    if (stockVoucherItems.isEmpty) {
      setState(() {
        _totalList.clear();
        _totalAmount = 0;
      });
    }
    setState(() {
      for (var element in stockVoucherItems) {
        _totalList.insert(stockVoucherItems.indexOf(element), element.subtotal);
        _totalAmount = _totalList.sum;
      }
    });
    print(_totalList);
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
            "Stock",
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.bold),
          )),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 4)
            ]),
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
                    )),
                Text(
                  "TrnNo. : $transactionNumber",
                  style: GoogleFonts.inter(),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      CupertinoSwitch(
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              isSelected = value;
                            });
                            if (value) {
                              _pageController.animateToPage(0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.decelerate);
                            } else {
                              _pageController.animateToPage(1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.decelerate);
                            }
                          }),
                      Text("  Purchase",
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold))
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                AddStockTransaction(context, _totalAmount),
                SubStockTransaction(context, _totalAmount)
              ],
            ),
          )
        ],
      ),
      bottomSheet: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 10)
          ]),
          height: 60,
          child: Row(
            children: [
              Expanded(
                  child: SizedBox(
                height: 60,
                child: TextButton(
                  onPressed: () {
                    deleteTransaction().then((value) {
                      removeStock().then((value) {
                        Navigator.pop(context);
                      });
                    });
                  },
                  child: Text(
                    "Delete",
                    style: GoogleFonts.inter(),
                  ),
                ),
              )),
              Expanded(
                  child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.indigo.shade700,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0))),
                  onPressed: () {
                    saveTransaction().then((value) {
                      addRemoveStock().then((value) {
                        setState(() {
                          stockVoucherItems.clear();
                        });
                        updateTotal();
                        Navigator.pop(context);
                      });
                    });
                  },
                  child: Text(
                    "Save",
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  SingleChildScrollView AddStockTransaction(
      BuildContext context, double total) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Column(
              children: stockVoucherItems
                  .map((e) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.indigo.shade200,
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(3)),
                                    child: Text(
                                      "# ${stockVoucherItems.indexOf(e) + 1}",
                                      style: GoogleFonts.inter(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold),
                                    )),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      stockVoucherItems.remove(e);
                                    });
                                    updateTotal();
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e.itemName,
                                    style: GoogleFonts.inter(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "₹ ${e.subtotal}",
                                    style: GoogleFonts.inter(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Subtotal = Item Rate x Quantity",
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "₹ ${e.rate} x ${e.itemQuantity} = ₹ ${e.subtotal}",
                                  style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "CurrQty : ${e.currentStock}",
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  Text(
                                    "Qty : ${e.currentStock! + e.itemQuantity}",
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ))
                  .toList(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: GoogleFonts.inter(fontSize: 20),
                  ),
                  Text(
                    "₹ $total",
                    style: GoogleFonts.inter(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () {
                updateTotal();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VoucherStockAdd(
                              refresh: () {
                                updateTotal();
                                setState(() {});
                              },
                            )));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle,
                    color: Colors.indigo.shade700,
                  ),
                  Text(
                    "  Add Items",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView SubStockTransaction(
      BuildContext context, double total) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Column(
              children: stockVoucherItems
                  .map((e) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.indigo.shade200,
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(3)),
                                    child: Text(
                                      "# ${stockVoucherItems.indexOf(e) + 1}",
                                      style: GoogleFonts.inter(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold),
                                    )),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      stockVoucherItems.remove(e);
                                    });
                                    updateTotal();
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e.itemName,
                                    style: GoogleFonts.inter(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "₹ ${e.subtotal}",
                                    style: GoogleFonts.inter(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Subtotal = Item Rate x Quantity",
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "₹ ${e.rate} x ${e.itemQuantity} = ₹ ${e.subtotal}",
                                  style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "CurrQty : ${e.currentStock}",
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  Text(
                                    "Qty : ${e.currentStock! - e.itemQuantity}",
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ))
                  .toList(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: GoogleFonts.inter(fontSize: 20),
                  ),
                  Text(
                    "₹ $total",
                    style: GoogleFonts.inter(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () {
                updateTotal();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VoucherStockAdd(
                              refresh: () {
                                updateTotal();
                                setState(() {});
                              },
                            )));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle,
                    color: Colors.indigo.shade700,
                  ),
                  Text(
                    "  Add Items",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
