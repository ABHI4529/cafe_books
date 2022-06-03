import 'dart:convert';
import 'package:cafe_books/component/ctextfield.dart';
import 'package:cafe_books/component/stextfield.dart';
import 'package:cafe_books/screens/clients/addclient.dart';
import 'package:cafe_books/screens/clients/clients.dart';
import 'package:cafe_books/screens/sale/AddVocuer.dart';
import 'package:cafe_books/screens/sale/edititem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';
import 'package:collection/collection.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';

class Sale extends StatefulWidget {
  Sale({Key? key}) : super(key: key);

  @override
  State<Sale> createState() => _SaleState();
}

final voucherCustomerName = TextEditingController();
final voucherSaleNumber = TextEditingController();
final voucherCustomerContact = TextEditingController();
String _clientSearch = "";
List clients = [];

var userEmail = FirebaseAuth.instance.currentUser?.email;
GlobalKey salekey = GlobalKey();
final saleCollection = FirebaseFirestore.instance
    .collection("book_data")
    .doc(userEmail)
    .collection("sales");

class _SaleState extends State<Sale> {
  DateFormat dateformat = DateFormat("dd - MMMM - yyyy");
  String voucherDate = "";
  double top = -500;
  double totalDiscount = 0;
  double itemsubtotal = 0;
  List<double> totaldiscountlist = [];
  List<double> totalsubamount = [];
  String paymentvalue = "cash";
  DateTime voucherDateFull = DateTime.now();
  @override
  void initState() {
    voucherDate = dateformat.format(DateTime.now());
    super.initState();
  }

  Future updateTotal() async {
    totaldiscountlist = [];
    totalsubamount = [];
    itemList.forEach((element) {
      setState(() {
        totaldiscountlist.insert(itemList.indexOf(element), element.discount);
        totalsubamount.insert(itemList.indexOf(element), element.subtotal);
        itemsubtotal = totalsubamount.sum;
        totalDiscount = totaldiscountlist.sum;
      });
    });
  }

  GlobalKey searchKeu = GlobalKey();
  int saleNumber = 0;
  final FocusNode _numberfocus = FocusNode();
  final FocusNode _voucherNumberfocus = FocusNode();
  double width = 100;

  Future saveBill() async {
    saleCollection.doc().set({
      "customerName": voucherCustomerName.text,
      "saleNumber": saleNumber,
      "orderCompleted": false,
      "customerContact": voucherCustomerContact.text,
      "paymentMethod": paymentvalue,
      "date": voucherDateFull,
      "totalSale": itemsubtotal - (itemsubtotal * totalDiscount / 100),
      "Items": jsonEncode(itemList.map((e) => e.toJson()).toList())
    }).then((value) async {
      StringBuffer istring = StringBuffer();

      for (var element in itemList) {
        istring.write(
            "${element.itemName} || ${element.itemQuantity} || ₹ ${element.rate} || ₹ ${element.subtotal} \n");
      }
      String whatsapptext =
          "Hey!! Here's your bill ${voucherCustomerName.text}\n"
          "order number : $saleNumber\n"
          "-----------------------------------------\n $istring\n"
          "-----------------------------------------\n"
          "_discount : $totalDiscount %_ *Total : ₹ $total* \n"
          "Thanks for visiting *Chapters of Diet*!";
      final whatsapplink = await WhatsAppUnilink(
          phoneNumber: "+91${voucherCustomerContact.text}", text: whatsapptext);
      // ignore: deprecated_member_use
      await launch('$whatsapplink');
      setState(() {
        itemList.clear();
        voucherCustomerName.clear();
        voucherCustomerContact.clear();
        total = 0;
        subtotal = 0;
        totalDiscount = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: salekey,
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
              "Sale",
              style: GoogleFonts.inter(
                  color: Colors.black, fontWeight: FontWeight.bold),
            )),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  blurRadius: 20,
                )
              ]),
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                      child: StreamBuilder(
                          stream: saleCollection.snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            return TextButton(
                              style: TextButton.styleFrom(
                                  alignment: Alignment.centerLeft),
                              onPressed: () {
                                setState(() {
                                  saleNumber = snapshot.data!.docs.length + 1;
                                  voucherSaleNumber.text =
                                      saleNumber.toString();
                                });
                                _voucherNumberfocus.requestFocus();
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height -
                                                200,
                                        child: CTextField(
                                          focus: _voucherNumberfocus,
                                          onSubmit: (value) {
                                            setState(() {
                                              saleNumber = int.parse(value);
                                            });
                                          },
                                          controller: voucherSaleNumber,
                                          placeholder: "Sale Number",
                                        ),
                                      );
                                    });
                              },
                              child: Text(
                                "Sale No. $saleNumber",
                                style: GoogleFonts.inter(color: Colors.black),
                              ),
                            );
                          })),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                          alignment: Alignment.centerRight),
                      onPressed: () async {
                        final DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2014),
                            lastDate: DateTime(2023));
                        if (date != null && date != DateTime.now()) {
                          setState(() {
                            voucherDate = dateformat.format(date);
                            voucherDateFull = date;
                          });
                        }
                      },
                      child: Text(
                        "${voucherDate}",
                        style: GoogleFonts.inter(color: Colors.black),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: clientCollectionRef.snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (_clientSearch.isEmpty) {
                      clients = snapshot.data!.docs;
                    } else {
                      clients = snapshot.data!.docs
                          .where((element) =>
                              element['clientName']
                                  .toString()
                                  .toLowerCase()
                                  .contains(_clientSearch.toLowerCase()) ||
                              element['clientContact']
                                  .toString()
                                  .toLowerCase()
                                  .contains(_clientSearch.toLowerCase()))
                          .toList();
                    }
                    return Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Focus(
                                    onFocusChange: (focus) {
                                      RenderBox renderBox = searchKeu
                                          .currentContext!
                                          .findRenderObject() as RenderBox;
                                      if (focus) {
                                        setState(() {
                                          top = renderBox.semanticBounds.top +
                                              renderBox.size.height +
                                              15;
                                          width = renderBox.size.width - 20;
                                        });
                                      } else {
                                        setState(() {
                                          top = -500;
                                        });
                                      }
                                    },
                                    child: CTextField(
                                      onTextChanged: (value) {
                                        setState(() {
                                          _clientSearch = value;
                                        });
                                      },
                                      controller: voucherCustomerName,
                                      placeholder: "Customer Name",
                                    ),
                                  )),
                              CTextField(
                                key: searchKeu,
                                focus: _numberfocus,
                                placeholder: "Cutomer Contact",
                                controller: voucherCustomerContact,
                              ),
                              Column(
                                children: itemList.map((e) {
                                  double total = e.subtotal -
                                      (e.subtotal * e.discount / 100);
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditVoucherItems(
                                                      itemName: e.itemName,
                                                      itemDiscount:
                                                          "${e.discount}",
                                                      itemRate: "${e.rate}",
                                                      itemQuantity:
                                                          "${e.itemQuantity}",
                                                      itemUnit: e.itemUnit,
                                                      refresh: () {
                                                        setState(() {
                                                          itemList.remove(e);
                                                          itemList.forEach(
                                                              (element) {
                                                            setState(() {
                                                              itemList.forEach(
                                                                  (element) {
                                                                totaldiscountlist.insert(
                                                                    itemList.indexOf(
                                                                        element),
                                                                    element
                                                                        .discount);
                                                                totalsubamount.insert(
                                                                    itemList.indexOf(
                                                                        element),
                                                                    element
                                                                        .subtotal);
                                                                itemsubtotal =
                                                                    totalsubamount
                                                                        .sum;
                                                                totalDiscount =
                                                                    totaldiscountlist
                                                                        .sum;
                                                              });
                                                            });
                                                          });
                                                        });
                                                      })));
                                    },
                                    child: Container(
                                      width: double.maxFinite,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.grey.shade200,
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                    child: Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3)),
                                                      child: Text(
                                                        "# ${itemList.indexOf(e) + 1}",
                                                        style:
                                                            GoogleFonts.inter(
                                                                fontSize: 9,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ),
                                                    Text(
                                                      "  ${e.itemName}",
                                                      style: GoogleFonts.inter(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                )),
                                                Text(
                                                  "₹ $total",
                                                  style: GoogleFonts.inter(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Item Subtotal",
                                                      style:
                                                          GoogleFonts.inter()),
                                                  Text(
                                                    "${e.itemQuantity} x ₹ ${e.rate} = ₹ ${e.itemQuantity * e.rate}",
                                                    style: GoogleFonts.inter(),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "Discount : ${e.discount} %",
                                                      style: GoogleFonts.inter(
                                                          color: const Color
                                                                  .fromARGB(255,
                                                              114, 105, 26))),
                                                  Text(
                                                    "₹ ${e.subtotal - total}",
                                                    style: GoogleFonts.inter(
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 114, 105, 26)),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total Discount : ${totalDiscount} %"),
                                    Text("Sub Total : ₹ ${itemsubtotal}")
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Total : ₹ ${itemsubtotal - (itemsubtotal * totalDiscount / 100)}",
                                      style: GoogleFonts.inter(
                                          decoration: TextDecoration.underline,
                                          decorationStyle:
                                              TextDecorationStyle.dashed,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.all(10)),
                                    onPressed: () {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VoucherItems(
                                                        refresh: () {},
                                                      )))
                                          .then((value) => updateTotal());
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_circle,
                                          color: Colors.indigo.shade600,
                                        ),
                                        Text("  Add Items",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.indigo.shade600))
                                      ],
                                    )),
                              ),
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Payment Method : ",
                                      style: GoogleFonts.inter(),
                                    ),
                                    DropdownButton<String>(
                                        value: paymentvalue,
                                        items: [
                                          DropdownMenuItem(
                                            value: "cash",
                                            child: Row(
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.moneyBill,
                                                  color: Colors.green.shade700,
                                                ),
                                                Text("   Cash",
                                                    style: GoogleFonts.inter()),
                                              ],
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: "upi",
                                            child: Row(
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.mobile,
                                                  color: Colors.blue.shade800,
                                                ),
                                                Text("   UPI",
                                                    style: GoogleFonts.inter()),
                                              ],
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: "card",
                                            child: Row(
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.creditCard,
                                                  color: Colors.red.shade600,
                                                ),
                                                Text("   Card",
                                                    style: GoogleFonts.inter()),
                                              ],
                                            ),
                                          )
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            paymentvalue = value.toString();
                                          });
                                        })
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                                      color: Colors.grey.withOpacity(0.4),
                                      blurRadius: 10)
                                ]),
                            width: width,
                            child: Column(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.grey))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Showing Saved Parties",
                                        style: GoogleFonts.inter(),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddClient()));
                                          },
                                          child: Text(
                                            "Add New Party",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: ListView(
                                    children: clients.map((e) {
                                      return ListTile(
                                        onTap: () {
                                          setState(() {
                                            voucherCustomerName.text =
                                                "${e['clientName']}";
                                            voucherCustomerContact.text =
                                                "${e['clientContact']}";
                                          });
                                          _numberfocus.requestFocus();
                                        },
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${e['clientName']}",
                                              style: GoogleFonts.inter(),
                                            ),
                                            Text(
                                              "Contact: ${e['clientContact']}",
                                              style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ],
                                        ),
                                        trailing: Text(
                                          "₹ ${e['clientBalance']}",
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }),
            )
          ],
        ),
        bottomSheet: BottomAppBar(
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 10)
            ]),
            height: 60,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Save",
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.indigo.shade600,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0))),
                      onPressed: () {
                        saveBill();
                      },
                      child: Text(
                        "Save & Send",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  child: IconButton(
                    icon: Icon(
                      Icons.print,
                      color: Colors.indigo.shade700,
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
