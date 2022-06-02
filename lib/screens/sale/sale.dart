import 'package:cafe_books/component/ctextfield.dart';
import 'package:cafe_books/component/stextfield.dart';
import 'package:cafe_books/screens/clients/addclient.dart';
import 'package:cafe_books/screens/clients/clients.dart';
import 'package:cafe_books/screens/sale/AddVocuer.dart';
import 'package:cafe_books/screens/sale/editvoucher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';
import 'package:collection/collection.dart';

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

GlobalKey salekey = GlobalKey();

class _SaleState extends State<Sale> {
  DateFormat dateformat = DateFormat("dd - MMMM - yyyy");
  String voucherDate = "";
  double top = -500;
  double totalDiscount = 0;
  double itemsubtotal = 0;
  List<double> totaldiscountlist = [];
  List<double> totalsubamount = [];
  @override
  void initState() {
    voucherDate = dateformat.format(DateTime.now());
    itemList.forEach((element) {
      setState(() {
        totaldiscountlist.insert(itemList.indexOf(element), element.discount);
        totalsubamount.insert(itemList.indexOf(element), element.subtotal);
        itemsubtotal = totalsubamount.sum;
        totalDiscount = totaldiscountlist.sum;
      });
    });
    super.initState();
  }

  GlobalKey searchKeu = GlobalKey();
  final FocusNode _numberfocus = FocusNode();
  final FocusNode _voucherNumberfocus = FocusNode();
  double width = 100;

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
                    child: TextButton(
                  style: TextButton.styleFrom(alignment: Alignment.centerLeft),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return CTextField(
                            focus: _voucherNumberfocus,
                            controller: voucherSaleNumber,
                            placeholder: "Sale Number",
                          );
                        });
                    _voucherNumberfocus.requestFocus();
                  },
                  child: Text(
                    "Sale No.",
                    style: GoogleFonts.inter(color: Colors.black),
                  ),
                )),
                Expanded(
                  child: TextButton(
                    style:
                        TextButton.styleFrom(alignment: Alignment.centerRight),
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
                                                        itemList
                                                            .forEach((element) {
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
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.grey.shade200,
                                        border: Border.all(color: Colors.grey)),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  child: Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3)),
                                                    child: Text(
                                                      "# ${itemList.indexOf(e) + 1}",
                                                      style: GoogleFonts.inter(
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Item Subtotal",
                                                    style: GoogleFonts.inter()),
                                                Text(
                                                  "${e.itemQuantity} x ₹ ${e.rate} = ₹ ${e.itemQuantity * e.rate}",
                                                  style: GoogleFonts.inter(),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
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
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              114,
                                                              105,
                                                              26)),
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
                                            builder: (context) => VoucherItems(
                                                  refresh: () {
                                                    setState(() {
                                                      itemList
                                                          .forEach((element) {
                                                        totaldiscountlist.insert(
                                                            itemList.indexOf(
                                                                element),
                                                            element.discount);
                                                        totalsubamount.insert(
                                                            itemList.indexOf(
                                                                element),
                                                            element.subtotal);
                                                        itemsubtotal =
                                                            totalsubamount.sum;
                                                        totalDiscount =
                                                            totaldiscountlist
                                                                .sum;
                                                      });
                                                    });
                                                  },
                                                )));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
