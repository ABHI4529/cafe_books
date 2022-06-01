import 'package:cafe_books/component/ctextfield.dart';
import 'package:cafe_books/datautil/saledatahandler.dart';
import 'package:cafe_books/screens/expense/expensevoucher.dart';
import 'package:cafe_books/screens/items/additem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class VoucherItems extends StatefulWidget {
  VoucherItems({Key? key}) : super(key: key);

  @override
  State<VoucherItems> createState() => _VoucherItemsState();
}

List items = [];
double top = -500;
double width = 200;
String itemSearchQury = "";
final itemQuantity = FocusNode();
final itemRateNode = FocusNode();
final discountNode = FocusNode();

final _voucherItemNameController = TextEditingController();
final _voucherItemQuantityController = TextEditingController();
final _voucherItemPriceController = TextEditingController();
final _voucherItemUnitcontoller = TextEditingController();
final _voucherItemDiscountController = TextEditingController();
final _voucherDiscountAmount = TextEditingController();
final _voucherDiscountPercentage = TextEditingController();

double subtotal = 0;
double total = 0;

List<SaleHandler> itemList = [];

class _VoucherItemsState extends State<VoucherItems> {
  @override
  void initState() {
    _voucherItemDiscountController.text = '0';
    super.initState();
  }

  GlobalKey itemGlobalkey = GlobalKey();
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
            "Add Items to Sale",
            style: GoogleFonts.inter(color: Colors.black),
          )),
      body: StreamBuilder(
        stream: itemCollectionRef.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (itemSearchQury.isEmpty) {
            items = snapshot.data!.docs;
          } else {
            items = snapshot.data!.docs
                .where((element) => element['itemName']
                    .toString()
                    .toLowerCase()
                    .contains(itemSearchQury.toLowerCase()))
                .toList();
          }
          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Focus(
                      onFocusChange: (focus) {
                        RenderBox renderBox = itemGlobalkey.currentContext!
                            .findRenderObject() as RenderBox;
                        if (focus) {
                          setState(() {
                            top = renderBox.semanticBounds.top +
                                renderBox.size.height +
                                -5;
                            width = renderBox.size.width - 20;
                          });
                        } else {
                          setState(() {
                            top = -500;
                          });
                        }
                      },
                      child: Container(
                        color: Colors.white,
                        child: CTextField(
                          key: itemGlobalkey,
                          controller: _voucherItemNameController,
                          onTextChanged: (value) {
                            setState(() {
                              itemSearchQury = value;
                            });
                          },
                          placeholder: "Item Name",
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: CTextField(
                            controller: _voucherItemQuantityController,
                            focus: itemQuantity,
                            onSubmit: (value) {
                              itemRateNode.requestFocus();
                            },
                            onTextChanged: (value) {
                              if (value.isEmpty || value == "1") {
                                setState(() {
                                  subtotal = double.parse(
                                      _voucherItemPriceController.text);
                                });
                                total = subtotal;
                              } else {
                                setState(() {
                                  subtotal = double.parse(value) *
                                      double.parse(
                                          _voucherItemPriceController.text);
                                  total = subtotal;
                                });
                              }
                            },
                            textInputType: TextInputType.number,
                            placeholder: "Quantity",
                          ),
                        ),
                        Expanded(
                          child: CTextField(
                            controller: _voucherItemUnitcontoller,
                            placeholder: "Unit",
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: CTextField(
                            onTextChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  subtotal = 0;
                                  total = subtotal;
                                });
                              } else {
                                setState(() {
                                  subtotal = double.parse(
                                          _voucherItemQuantityController.text) *
                                      double.parse(value);

                                  total = subtotal;
                                });
                              }
                            },
                            focus: itemRateNode,
                            onSubmit: (value) {
                              discountNode.requestFocus();
                            },
                            controller: _voucherItemPriceController,
                            placeholder: "Rate (Price/Unit)",
                          ),
                        ),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(top: 20),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    width: double.maxFinite,
                    color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.only(bottom: 10),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.5))),
                          child: Text("Totals & Taxes",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Sub Total (Rate x Qty)",
                                  style: GoogleFonts.inter()),
                              Text("₹ ${subtotal}",
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text("Discount",
                                    style: GoogleFonts.inter()),
                              ),
                              Expanded(
                                child: CTextField(
                                  focus: discountNode,
                                  controller: _voucherItemDiscountController,
                                  onTextChanged: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        total = subtotal;
                                        _voucherDiscountAmount.text = "0.0";
                                      });
                                    } else {
                                      setState(() {
                                        total = subtotal -
                                            (subtotal *
                                                double.parse(value) /
                                                100);
                                        _voucherDiscountAmount.text =
                                            (total - subtotal).toString();
                                      });
                                    }
                                  },
                                  widgetPrefix: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.indigo.shade600,
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(7),
                                            bottomRight: Radius.circular(7))),
                                    child: const Icon(
                                      Icons.percent,
                                      size: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: CTextField(
                                  controller: _voucherDiscountAmount,
                                  widgetPrefix: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(7),
                                            bottomRight: Radius.circular(7))),
                                    child: const Icon(
                                      Icons.currency_rupee,
                                      size: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Amount :",
                                style: GoogleFonts.inter(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "₹ ${total}",
                                style: GoogleFonts.inter(
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.dashed,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                top: top,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.4), blurRadius: 10)
                      ]),
                  width: width,
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: Colors.grey))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Showing Saved Items",
                              style: GoogleFonts.inter(),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddItem()));
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
                        child: ListView(
                          children: items.map((e) {
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  _voucherItemNameController.text =
                                      e['itemName'].toString();
                                  _voucherItemPriceController.text =
                                      e['itemPrice'].toString();
                                  _voucherItemUnitcontoller.text =
                                      e['itemUnit'].toString();
                                });
                                itemQuantity.requestFocus();
                                if (_voucherItemQuantityController
                                    .text.isEmpty) {
                                  setState(() {
                                    total = subtotal;
                                  });
                                } else {
                                  setState(() {
                                    subtotal = double.parse(
                                            _voucherItemQuantityController
                                                .text) *
                                        double.parse(
                                            _voucherItemPriceController.text);
                                    total = subtotal;
                                  });
                                }
                                if (_voucherItemDiscountController
                                    .text.isEmpty) {
                                  setState(() {
                                    total = subtotal;
                                  });
                                } else {
                                  setState(() {
                                    total = subtotal -
                                        (subtotal *
                                            double.parse(
                                                _voucherItemDiscountController
                                                    .text) /
                                            100);
                                  });
                                }
                              },
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${e['itemName']}",
                                    style: GoogleFonts.inter(),
                                  ),
                                  Text(
                                    "Unit: ${e['itemUnit']}",
                                    style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                "₹ ${e['itemPrice']}",
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
      bottomSheet: BottomAppBar(
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.grey.shade400, blurRadius: 10)
          ]),
          child: Row(
            children: [
              Expanded(
                  child: SizedBox(
                      height: 60,
                      child: TextButton(
                          onPressed: () {
                            itemList.add(SaleHandler(
                              _voucherItemNameController.text,
                              int.parse(_voucherItemQuantityController.text),
                              _voucherItemUnitcontoller.text,
                              double.parse(_voucherItemPriceController.text),
                              double.parse(_voucherItemDiscountController.text),
                              subtotal,
                            ));
                          },
                          child: Text(
                            "Save & New",
                            style: GoogleFonts.inter(),
                          )))),
              Expanded(
                  child: SizedBox(
                      height: 60,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)),
                              backgroundColor: const Color(0xff001F54)),
                          onPressed: () {},
                          child: Text(
                            "Save",
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ))))
            ],
          ),
        ),
      ),
    );
  }
}
