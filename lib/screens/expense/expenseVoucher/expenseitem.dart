import 'package:cafe_books/component/ctextfield.dart';
import 'package:cafe_books/datautil/expensedatavoucher.dart';
import 'package:cafe_books/screens/expense/addexpense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class VoucherExpenseItem extends StatefulWidget {
  Function refresh;
  VoucherExpenseItem({Key? key, required this.refresh}) : super(key: key);

  @override
  State<VoucherExpenseItem> createState() => _VoucherExpenseItemState();
}

List<ExpenseItems> expenseVoucherList = [];

class _VoucherExpenseItemState extends State<VoucherExpenseItem> {
  final GlobalKey _itemNamekey = GlobalKey();
  double left = -500;
  double top = 0;
  double width = 0;
  final _expenseItemName = TextEditingController();
  final _expenseItemQuantity = TextEditingController(text: "1");
  final _expenseItemPrice = TextEditingController();
  final _expenseItemDescription = TextEditingController();
  final _itemNameNode = FocusNode();
  final _itemQuantityNode = FocusNode();
  final _itemPriceNode = FocusNode();
  final _itemDescriptionNode = FocusNode();
  double _subtotal = 0;
  String _filter = "";
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
            "Add Item to Expense",
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.bold),
          )),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Focus(
                  onFocusChange: (focus) {
                    RenderBox box = _itemNamekey.currentContext!
                        .findRenderObject() as RenderBox;
                    if (focus) {
                      setState(() {
                        left = box.semanticBounds.left + box.size.height - 40;
                        top = box.semanticBounds.top + box.size.height;
                        width = box.size.width - 20;
                      });
                    } else {
                      setState(() {
                        left = -500;
                        width = 0;
                      });
                    }
                  },
                  child: CTextField(
                    focus: _itemNameNode,
                    controller: _expenseItemName,
                    key: _itemNamekey,
                    placeholder: "Item Name",
                    onTextChanged: (value) {
                      setState(() {
                        _filter = value;
                      });
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CTextField(
                        focus: _itemQuantityNode,
                        controller: _expenseItemQuantity,
                        placeholder: "Quantity",
                        onTextChanged: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              _subtotal = double.parse(_expenseItemPrice.text);
                            });
                          } else {
                            setState(() {
                              _subtotal = double.parse(_expenseItemPrice.text) *
                                  double.parse(value);
                            });
                          }
                        },
                        onSubmit: (value) {
                          _itemPriceNode.requestFocus();
                        },
                      ),
                    ),
                    Expanded(
                      child: CTextField(
                        focus: _itemPriceNode,
                        onSubmit: (value) {
                          _itemDescriptionNode.requestFocus();
                        },
                        onTextChanged: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              _subtotal = 0;
                            });
                          } else {
                            setState(() {
                              _subtotal =
                                  double.parse(_expenseItemQuantity.text) *
                                      double.parse(value);
                            });
                          }
                        },
                        controller: _expenseItemPrice,
                        placeholder: "Price",
                      ),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 80,
                  child: CupertinoTextField(
                    focusNode: _itemDescriptionNode,
                    style: GoogleFonts.inter(),
                    controller: _expenseItemDescription,
                    maxLines: 7,
                    placeholder: "Description ",
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Subtotal = Quantity x Price",
                          style: GoogleFonts.inter(),
                        ),
                        Text(
                          "₹ $_subtotal",
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: left,
            top: top,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: width,
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.4), blurRadius: 10)
                  ],
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Saved Items",
                          style: GoogleFonts.inter(),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddExpense()));
                            },
                            child: Text(
                              "Add New Item",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: expenseCollectionRef.snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        List _filterList = [];
                        if (_filter.isEmpty) {
                          _filterList = snapshot.data!.docs;
                        } else {
                          _filterList = snapshot.data!.docs
                              .where((e) => e['expName']
                                  .toString()
                                  .toLowerCase()
                                  .contains(_filter.toLowerCase()))
                              .toList();
                        }
                        return ListView(
                          children: _filterList.map((e) {
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  _expenseItemName.text = "${e['expName']}";
                                  _expenseItemPrice.text = "${e['expAmount']}";
                                  _itemQuantityNode.requestFocus();
                                  _subtotal = double.parse(
                                          "${e['expAmount']}") *
                                      double.parse(_expenseItemQuantity.text);
                                });
                              },
                              title: Text(
                                "${e['expName']}",
                                style: GoogleFonts.inter(),
                              ),
                              trailing: Text(
                                "₹ ${e['expAmount']}",
                                style: GoogleFonts.inter(),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      bottomSheet: BottomAppBar(
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        expenseVoucherList.add(ExpenseItems(
                            _expenseItemName.text,
                            int.parse(_expenseItemQuantity.text),
                            double.parse(_expenseItemPrice.text),
                            _expenseItemDescription.text,
                            _subtotal));
                      });
                      widget.refresh();
                      _itemNameNode.requestFocus();
                    },
                    child: Text(
                      "Save & New",
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.indigo.shade700),
                    onPressed: () {
                      setState(() {
                        expenseVoucherList.add(ExpenseItems(
                            _expenseItemName.text,
                            int.parse(_expenseItemQuantity.text),
                            double.parse(_expenseItemPrice.text),
                            _expenseItemDescription.text,
                            _subtotal));
                      });
                      Navigator.pop(context);
                      widget.refresh();
                    },
                    child: Text(
                      "Save",
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    ),
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
