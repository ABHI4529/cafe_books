import 'package:cafe_books/component/ctextfield.dart';
import 'package:cafe_books/screens/homepage/homepage.dart';
import 'package:cafe_books/screens/stock/addstockitems.dart';
import 'package:cafe_books/screens/stock/voucherstock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../datautil/stockvoucherdata.dart';

class EditVoucherStockItem extends StatefulWidget {
  Function refresh;
  EditVoucherStockItem({Key? key, required this.refresh}) : super(key: key);

  @override
  State<EditVoucherStockItem> createState() => _EditVoucherStockItemState();
}

class _EditVoucherStockItemState extends State<EditVoucherStockItem> {
  double top = -500;
  double width = 0;
  GlobalKey itemKey = GlobalKey();
  List filterItems = [];
  String filterString = "";
  final _stockNameController = TextEditingController();
  final _stockUnitController = TextEditingController();
  final _stockPriceController = TextEditingController();
  final _stockQuantityController = TextEditingController(text: "1");
  final itemNameNode = FocusNode();
  final quantityNode = FocusNode();
  String docID = "";
  final unitNode = FocusNode();
  final priceNode = FocusNode();
  int _currStock = 0;
  double _subtotal = 0;
  double _total = 0;
  Future clearFields() async {
    setState(() {
      _stockNameController.clear();
      _stockUnitController.clear();
      _stockQuantityController.clear();
      _stockPriceController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
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
            "Add Items",
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.bold),
          )),
      body: StreamBuilder(
          stream: null,
          builder: (context, snapshot) {
            return Stack(
              children: [
                Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Focus(
                            onFocusChange: (focus) {
                              RenderBox box = itemKey.currentContext!
                                  .findRenderObject() as RenderBox;
                              if (focus) {
                                setState(() {
                                  top = box.semanticBounds.top +
                                      box.size.height -
                                      10;
                                  width = box.size.width - 20;
                                });
                              } else {
                                setState(() {
                                  top = -500;
                                  width = 0;
                                });
                              }
                            },
                            child: CTextField(
                              controller: _stockNameController,
                              onTextChanged: (value) {
                                setState(() {
                                  filterString = value;
                                });
                              },
                              focus: itemNameNode,
                              key: itemKey,
                              placeholder: "Item Name",
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CTextField(
                                  onSubmit: (value) {
                                    unitNode.requestFocus();
                                  },
                                  onTextChanged: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        _subtotal = double.parse(
                                            _stockPriceController.text);
                                        _total = double.parse(
                                            _stockPriceController.text);
                                      });
                                    } else {
                                      setState(() {
                                        _subtotal = double.parse(
                                                _stockPriceController.text) *
                                            int.parse(value);
                                        _total = double.parse(
                                                _stockPriceController.text) *
                                            int.parse(value);
                                      });
                                    }
                                  },
                                  focus: quantityNode,
                                  textInputType: TextInputType.number,
                                  controller: _stockQuantityController,
                                  placeholder: "Quantity",
                                ),
                              ),
                              Expanded(
                                child: CTextField(
                                  onSubmit: (value) {
                                    priceNode.requestFocus();
                                  },
                                  focus: unitNode,
                                  controller: _stockUnitController,
                                  placeholder: "Unit",
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CTextField(
                                  focus: priceNode,
                                  onTextChanged: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        _subtotal = 0.0;
                                        _total = 0;
                                      });
                                    } else {
                                      setState(() {
                                        _subtotal = int.parse(
                                                _stockQuantityController.text) *
                                            double.parse(value);
                                        _total = int.parse(
                                                _stockQuantityController.text) *
                                            double.parse(value);
                                      });
                                    }
                                  },
                                  textInputType: TextInputType.number,
                                  controller: _stockPriceController,
                                  placeholder: "Price",
                                ),
                              ),
                              Expanded(child: Container()),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      color: Colors.white,
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.maxFinite,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                            child: Text(
                              "Total & Subtotal",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Subtotal (Rate x Quantity)",
                                  style: GoogleFonts.inter(),
                                ),
                                Text(
                                  "₹  $_subtotal",
                                  style: GoogleFonts.inter(),
                                )
                              ],
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total",
                                    style: GoogleFonts.inter(fontSize: 20),
                                  ),
                                  Text(
                                    "₹ $_total",
                                    style: GoogleFonts.inter(
                                        fontSize: 20,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                        decorationStyle:
                                            TextDecorationStyle.dashed),
                                  )
                                ],
                              ))
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: top,
                  child: Container(
                    width: width,
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 10)
                        ]),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Showing Saved Items",
                                style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddStockItem()));
                                  },
                                  child: Text(
                                    "Add Item",
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          ),
                        ),
                        Expanded(
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("book_data")
                                .doc("${user?.email}")
                                .collection("stock")
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (filterString.isEmpty) {
                                filterItems = snapshot.data!.docs;
                              } else {
                                filterItems = snapshot.data!.docs
                                    .where((element) => element['stockItemName']
                                        .toString()
                                        .toLowerCase()
                                        .contains(filterString.toLowerCase()))
                                    .toList();
                              }
                              return ListView(
                                children: filterItems
                                    .map((e) => ListTile(
                                          onTap: () {
                                            setState(() {
                                              _stockNameController.text =
                                                  e['stockItemName'];
                                              _stockUnitController.text =
                                                  e['stockItemUnit'];
                                              _stockPriceController.text =
                                                  e['stockItemPrice']
                                                      .toString();
                                              _subtotal = e['stockItemPrice'];
                                              _total = e['stockItemPrice'];
                                              _currStock =
                                                  e['stockItemClosing'];
                                              docID = e.id;
                                            });
                                            quantityNode.requestFocus();
                                          },
                                          title: Text(
                                            "${e['stockItemName']}",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          trailing: Text(
                                              "₹ ${e['stockItemPrice']} / ${e['stockItemUnit']}",
                                              style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold)),
                                        ))
                                    .toList(),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
      bottomSheet: BottomAppBar(
        child: Container(
          height: 60,
          child: Row(children: [
            Expanded(
                child: SizedBox(
              height: 60,
              child: TextButton(
                onPressed: () {
                  widget.refresh();
                  setState(() {
                    stockVoucherItems.add(StockItem(
                        _stockNameController.text,
                        int.parse(_stockQuantityController.text),
                        _stockUnitController.text,
                        double.parse(_stockPriceController.text),
                        _total,
                        _currStock,
                        docID));
                  });
                  widget.refresh();
                  clearFields().then((value) {
                    itemNameNode.requestFocus();
                  });
                },
                child: Text(
                  "Save & New",
                  style: GoogleFonts.inter(),
                ),
              ),
            )),
            Expanded(
                child: SizedBox(
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    primary: Colors.indigo.shade700),
                onPressed: () {
                  setState(() {
                    stockVoucherItems.add(StockItem(
                        _stockNameController.text,
                        int.parse(_stockQuantityController.text),
                        _stockUnitController.text,
                        double.parse(_stockPriceController.text),
                        _total,
                        _currStock,
                        docID));
                  });
                  widget.refresh();
                  clearFields().then((value) {
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  "Save",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
              ),
            ))
          ]),
        ),
      ),
    );
  }
}
