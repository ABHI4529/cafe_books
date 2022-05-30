import 'package:cafe_books/component/ctextfield.dart';
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

import '../../datautil/expensedatavoucher.dart';

class ExpenseVoucer extends StatefulWidget {
  ExpenseVoucer({Key? key}) : super(key: key);

  @override
  State<ExpenseVoucer> createState() => _ExpenseVoucerState();
}

List<ExpenseItems> expenseVoucherList = [];
final expenseQuantity = TextEditingController(text: "1");
final expensePrice = TextEditingController();
final expenseDescription = TextEditingController();

class _ExpenseVoucerState extends State<ExpenseVoucer> {
  DateFormat dateformat = DateFormat("dd - MMMM - yyyy");
  String voucherDate = "";

  @override
  void initState() {
    voucherDate = dateformat.format(DateTime.now());
    super.initState();
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
            SizedBox(
                height: 300,
                child: StreamBuilder(
                  stream: expenseCollectionRef.snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            "${snapshot.data?.docs[index]['expName']}",
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                              "₹  ${snapshot.data?.docs[index]['expAmount']}",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold)),
                          onTap: () {
                            setState(() {
                              itemPriceController.text =
                                  "${snapshot.data?.docs[index]['expAmount']}";
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return addExpenceItem(
                                      snapshot, index, context);
                                });
                          },
                        );
                      },
                    );
                  },
                )),
            Container(
                padding: const EdgeInsets.all(10),
                color: const Color(0xff1A659E),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Item Name",
                      style: GoogleFonts.inter(color: Colors.white),
                    ),
                    Container(
                      width: 200,
                      alignment: Alignment.center,
                      child: Text(
                        "Quantity",
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                    ),
                    Text(
                      "Price",
                      style: GoogleFonts.inter(color: Colors.white),
                    )
                  ],
                )),
            SizedBox(
              height: 200,
              child: ListView(
                children: expenseVoucherList.map((e) {
                  return ListTile(
                    shape: const Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.5)),
                    leading: Text(e.itemName, style: GoogleFonts.inter()),
                    onTap: () {},
                    title: Container(
                      alignment: Alignment.center,
                      width: 200,
                      child: Text(e.quantity.toString(),
                          style: GoogleFonts.inter()),
                    ),
                    trailing: Text(
                      e.price.toString(),
                      style: GoogleFonts.inter(),
                    ),
                  );
                }).toList(),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.centerRight,
                child: Text(
                  "Total",
                  style: GoogleFonts.inter(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xff1A659E)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchExpense()));
                        },
                        child: Text(
                          "Add Items",
                          style: GoogleFonts.inter(),
                        )),
                  ),
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
                      "Cancle",
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
                                "${snapshot.data?.docs[index]['expName']}",
                                int.parse(expenseQuantity.text),
                                double.parse(itemPriceController.text),
                                itemDescriptionController.text));
                            Navigator.pop(context);
                          });
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
