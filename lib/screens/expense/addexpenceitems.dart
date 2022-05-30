import 'package:cafe_books/component/ctextfield.dart';
import 'package:cafe_books/component/usnackbar.dart';
import 'package:cafe_books/datautil/expensedatavoucher.dart';
import 'package:cafe_books/screens/expense/addexpense.dart';
import 'package:cafe_books/screens/expense/expensevoucher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchExpense extends StatefulWidget {
  SearchExpense({Key? key}) : super(key: key);

  @override
  State<SearchExpense> createState() => _SearchExpenseState();
}

class _SearchExpenseState extends State<SearchExpense> {
  String _searchText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: CupertinoTextField(
          onChanged: (value) {
            setState(() {
              _searchText = value;
            });
          },
          clearButtonMode: OverlayVisibilityMode.editing,
          padding: const EdgeInsets.all(10),
          placeholder: "Search",
          style: GoogleFonts.inter(),
        ),
      ),
      body: StreamBuilder(
        stream: expenseCollectionRef.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List filterList = [];
          if (_searchText.isEmpty) {
            filterList = snapshot.data!.docs;
          } else {
            filterList = snapshot.data!.docs
                .where((element) => element['expName']
                    .toString()
                    .toLowerCase()
                    .contains(_searchText.toLowerCase()))
                .toList();
            print(filterList);
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
              children: filterList.map((e) {
            return ListTile(
              title: Text(
                e['expName'],
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                "₹ ${e['expAmount']}",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return AddExpenseItem(
                        itemName: "${e['expName']}",
                        itemPrice: "${e['expAmount']}",
                      );
                    });
              },
            );
          }).toList());
        },
      ),
    );
  }
}

class AddExpenseItem extends StatefulWidget {
  String itemName;
  String itemPrice;
  AddExpenseItem({Key? key, required this.itemName, required this.itemPrice})
      : super(key: key);

  @override
  State<AddExpenseItem> createState() => _AddExpenseItemState();
}

class _AddExpenseItemState extends State<AddExpenseItem> {
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController(text: "1");
  final _descriptionController = TextEditingController();
  @override
  void initState() {
    _priceController.text = widget.itemPrice;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.itemName,
                style: GoogleFonts.inter(fontSize: 20),
              ),
            ),
            Container(
              height: 20,
            ),
            CTextField(
              controller: _priceController,
              placeholder: "Price",
            ),
            CTextField(
              controller: _quantityController,
              placeholder: "Quantity",
            ),
            Container(
              height: 100,
              padding: const EdgeInsets.all(10),
              child: CupertinoTextField(
                controller: _descriptionController,
                style: GoogleFonts.inter(),
                placeholder: "Description",
                padding: const EdgeInsets.all(10),
                maxLines: 5,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 30),
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
                    width: 150,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xff1A659E)),
                        onPressed: () {
                          setState(() {
                            if (expenseVoucherList.contains(ExpenseItems(
                                widget.itemName,
                                int.parse(_quantityController.text),
                                double.parse(_priceController.text),
                                _descriptionController.text))) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  USnackbar(
                                      message: "Already Contains that item"));
                            } else {
                              expenseVoucherList.add(ExpenseItems(
                                  widget.itemName,
                                  int.parse(_quantityController.text),
                                  double.parse(_priceController.text),
                                  _descriptionController.text));
                            }
                          });
                        },
                        child: Text("Add", style: GoogleFonts.inter())),
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
