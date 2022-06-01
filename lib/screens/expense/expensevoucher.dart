import 'package:cafe_books/component/ctextfield.dart';
import 'package:cafe_books/component/ditemsearch.dart';
import 'package:cafe_books/component/dtextfield.dart';
import 'package:cafe_books/screens/expense/addexpenceitems.dart';
import 'package:cafe_books/screens/expense/addexpense.dart';
import 'package:cafe_books/screens/items/additem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:editable/editable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:searchfield/searchfield.dart';
import 'package:textfield_search/textfield_search.dart';

import '../../datautil/expensedatavoucher.dart';

class ExpenseVoucer extends StatefulWidget {
  ExpenseVoucer({Key? key}) : super(key: key);

  @override
  State<ExpenseVoucer> createState() => _ExpenseVoucerState();
}

List<ExpenseItems> expenseVoucherList = [];
final expenseQuantity = TextEditingController();
final expensePrice = TextEditingController();
final expenseAmount = TextEditingController();
final expenseDescription = TextEditingController();
List<double> total = [];

class _ExpenseVoucerState extends State<ExpenseVoucer> {
  DateFormat dateformat = DateFormat("dd - MMMM - yyyy");
  String voucherDate = "";

  @override
  void initState() {
    voucherDate = dateformat.format(DateTime.now());
    super.initState();
  }

  @override
  void dispose() {
    total.clear();
    expenseVoucherList.clear();
    super.dispose();
  }

  final FocusNode _itemNameFocus = FocusNode();
  final FocusNode _itemQtyFocus = FocusNode();
  final FocusNode _itemRateFocus = FocusNode();
  final FocusNode _itemDescriptionFocus = FocusNode();

  final _itemNameControllerupdate = TextEditingController();
  final _expenseQuantityupdate = TextEditingController();
  final _priceControllerupdate = TextEditingController();
  final _itemDescriptionControllerupdate = TextEditingController();

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
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 20)
              ]),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Expense No. ",
                      style: GoogleFonts.inter(color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2014),
                          lastDate: DateTime(2023));
                      if (date != null && date != DateTime.now()) {
                        setState(() {
                          voucherDate = dateformat.format(date);
                        });
                      }
                    },
                    child: Text(
                      "${voucherDate}",
                      style: GoogleFonts.inter(color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              child: DataTable(
                  headingRowHeight: 30,
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.blue.shade600),
                  showCheckboxColumn: false,
                  columns: [
                    DataColumn(
                        label: Container(
                      width: 150,
                      child: Text(
                        "Item Name",
                        style: GoogleFonts.inter(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
                    DataColumn(
                        label: Text(
                      "Qty",
                      style: GoogleFonts.inter(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text(
                      "Rate",
                      style: GoogleFonts.inter(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text(
                      "Amount",
                      style: GoogleFonts.inter(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))
                  ],
                  dataRowHeight: 50,
                  rows: expenseVoucherList
                      .map((e) => DataRow(
                              cells: [
                                DataCell(Text(e.itemName)),
                                DataCell(Text(e.quantity.toString())),
                                DataCell(Text(e.price.toString())),
                                DataCell(Text("${e.quantity * e.price}"))
                              ],
                              onSelectChanged: (selected) {
                                setState(() {
                                  _expenseQuantityupdate.text =
                                      e.quantity.toString();
                                  _priceControllerupdate.text =
                                      e.price.toString();
                                  expenseDescription.text = e.description;
                                });
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return updateitem(e, context);
                                    });
                              }))
                      .toList()),
            ),
            Container(
              width: double.maxFinite,
              child: Row(
                children: [
                  Container(
                    width: 200,
                    child: StreamBuilder(
                        stream: expenseCollectionRef.snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return Container(
                            padding: const EdgeInsets.all(10),
                            child: SearchField(
                              focusNode: _itemNameFocus,
                              onSubmit: (value) {
                                itemNameController.text = value;
                                _itemQtyFocus.requestFocus();
                              },
                              controller: itemNameController,
                              onSuggestionTap: (suggestion) {
                                itemNameController.text = suggestion.searchKey;
                                _itemQtyFocus.requestFocus();
                                setState(() {
                                  itemPriceController.text =
                                      suggestion.item.toString();
                                });
                              },
                              suggestions: snapshot.data!.docs
                                  .map((e) => SearchFieldListItem(
                                      '${e['expName']}',
                                      item: "${e['expAmount']}"))
                                  .toList(),
                            ),
                          );
                        }),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 30,
                        child: TextField(
                          controller: expenseQuantity,
                          focusNode: _itemQtyFocus,
                          onChanged: (value) {
                            if (value.isEmpty || value == "0") {
                              expenseAmount.text = "0";
                            } else {
                              setState(() {
                                expenseAmount.text = double.parse(
                                        "${int.parse(value) * double.parse(itemPriceController.text)}")
                                    .toString();
                              });
                            }
                          },
                          onSubmitted: (value) {
                            _itemRateFocus.requestFocus();
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 30,
                        child: TextField(
                          controller: itemPriceController,
                          focusNode: _itemRateFocus,
                          onChanged: (value) {
                            if (value.isEmpty || value == '0') {
                              setState(() {
                                expenseAmount.text = "0";
                              });
                            } else {
                              setState(() {
                                expenseAmount.text = double.parse(
                                        "${int.parse(expenseQuantity.text) * double.parse(value)}")
                                    .toString();
                              });
                            }
                          },
                          onSubmitted: (value) {
                            setState(() {
                              expenseVoucherList.add(ExpenseItems(
                                  itemNameController.text,
                                  int.parse(expenseQuantity.text),
                                  double.parse(value),
                                  itemDescriptionController.text));
                              total.add(double.parse(expenseAmount.text));
                              itemNameController.clear();
                              expenseQuantity.clear();
                              itemPriceController.clear();
                              expenseAmount.clear();
                              print(total);
                            });
                            _itemNameFocus.requestFocus();
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 30,
                      child: TextField(
                        enabled: false,
                        controller: expenseAmount,
                        focusNode: _itemDescriptionFocus,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
                color: Colors.white,
                padding: const EdgeInsets.all(10),
                alignment: Alignment.centerRight,
                child: Text(
                  "Total : ₹ ${total.sum}",
                  style: GoogleFonts.inter(fontSize: 20),
                )),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xff1A659E)),
                        onPressed: () {},
                        child: Text(
                          "Finish",
                          style: GoogleFonts.inter(),
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Dialog updateitem(ExpenseItems e, BuildContext context) {
    return Dialog(
      child: Container(
        height: 450,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              e.itemName,
              style:
                  GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 20,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 5.0,
                    ),
                    child: Text(
                      "Quantity",
                      style: GoogleFonts.inter(),
                    ),
                  ),
                  CupertinoTextField(
                    controller: _expenseQuantityupdate,
                    placeholder: "Quantity",
                    padding: const EdgeInsets.all(10),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, top: 10),
                    child: Text(
                      "Price",
                      style: GoogleFonts.inter(),
                    ),
                  ),
                  CupertinoTextField(
                    controller: _priceControllerupdate,
                    placeholder: "Quantity",
                    padding: const EdgeInsets.all(10),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, top: 10),
                    child: Text(
                      "Description",
                      style: GoogleFonts.inter(),
                    ),
                  ),
                  CupertinoTextField(
                    maxLines: 5,
                    controller: _itemDescriptionControllerupdate,
                    placeholder: "Description",
                    padding: const EdgeInsets.all(10),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        expenseVoucherList.remove(e);
                        total.removeAt(expenseVoucherList.indexOf(e));
                        print(total);
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Delete",
                      style: GoogleFonts.inter(color: Colors.red),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xff1A659E)),
                        onPressed: () {
                          setState(() {
                            expenseVoucherList[expenseVoucherList.indexOf(e)] =
                                ExpenseItems(
                                    e.itemName,
                                    int.parse(_expenseQuantityupdate.text),
                                    double.parse(_priceControllerupdate.text),
                                    itemDescriptionController.text);
                            total[expenseVoucherList.indexOf(e)] = double.parse(
                                "${int.parse(_expenseQuantityupdate.text) * double.parse(_priceControllerupdate.text)}");
                          });
                          Navigator.pop(context);
                        },
                        child: Text("Update",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold))),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Dialog addExpenceItem(AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
      int index, BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 450,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${snapshot.data?.docs[index]['expName']}",
              style:
                  GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 20,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 5.0,
                    ),
                    child: Text(
                      "Quantity",
                      style: GoogleFonts.inter(),
                    ),
                  ),
                  CupertinoTextField(
                    controller: expenseQuantity,
                    placeholder: "Quantity",
                    padding: const EdgeInsets.all(10),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, top: 10),
                    child: Text(
                      "Price",
                      style: GoogleFonts.inter(),
                    ),
                  ),
                  CupertinoTextField(
                    controller: itemPriceController,
                    placeholder: "Quantity",
                    padding: const EdgeInsets.all(10),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, top: 10),
                    child: Text(
                      "Description",
                      style: GoogleFonts.inter(),
                    ),
                  ),
                  CupertinoTextField(
                    maxLines: 5,
                    controller: itemDescriptionController,
                    placeholder: "Description",
                    padding: const EdgeInsets.all(10),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Delete",
                      style: GoogleFonts.inter(color: Colors.red),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xff1A659E)),
                        onPressed: () {
                          setState(() {
                            expenseVoucherList.add(ExpenseItems(
                                snapshot.data!.docs[index]['expName']
                                    .toString(),
                                int.parse(expenseQuantity.text),
                                double.parse(itemPriceController.text),
                                itemDescriptionController.text));
                            total.add(double.parse(
                                "${int.parse(expenseQuantity.text) * double.parse(itemPriceController.text)}"));
                          });

                          Navigator.pop(context);
                        },
                        child: Text("Add",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold))),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
