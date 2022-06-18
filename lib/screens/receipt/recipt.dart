import 'package:cafe_books/component/ctextfield.dart';
import 'package:cafe_books/screens/homepage/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../clients/addclient.dart';
import '../sale/sale.dart';

class Receipt extends StatefulWidget {
  Receipt({Key? key}) : super(key: key);

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  double top = -500;
  double width = 0;
  int receiptNumber = 0;

  String _clientSearch = "";
  var voucherclientNameNode = FocusNode();

  var _voucherNumberfocus = FocusNode();
  GlobalKey searchKeu = GlobalKey();

  var dateformat = DateFormat("dd - MMMM - yyyy");

  String voucherDate = "";

  DateTime voucherDateFull = DateTime.now();

  var _numberfocus = FocusNode();

  String _clientID = "";

  double existingCl = 0;
  final receiptCollection = FirebaseFirestore.instance
      .collection('book_data')
      .doc("${user?.email}")
      .collection("receipts");

  String paymentvalue = "cash";
  Future updateReceipt() async {
    QuerySnapshot receiptNum = await receiptCollection.get();
    setState(() {
      receiptNumber = receiptNum.docs.length + 1;
    });
  }

  final receivedController = TextEditingController();
  String receivedAmount = "";
  final descriptionController = TextEditingController();

  Future saveRecipt() async {
    receiptCollection.doc().set({
      "customerName": voucherCustomerName.text,
      "customerContact": voucherCustomerContact.text,
      "date": voucherDateFull,
      "receiptAmount": double.parse(receivedAmount),
      "description": descriptionController.text,
      "paymentMethod": paymentvalue
    });
  }

  @override
  void initState() {
    updateReceipt();
    super.initState();
  }

  Future updateClosingBal(String clientID, double existingCl) async {
    clientCollectionRef
        .doc(clientID)
        .update({"closing": existingCl - double.parse(receivedAmount)});
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
          "Receipt",
          style: GoogleFonts.inter(
              fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
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
                        stream: receiptCollection.snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          return TextButton(
                            style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft),
                            onPressed: () {
                              setState(() {
                                receiptNumber = snapshot.data!.docs.length + 1;
                                voucherSaleNumber.text =
                                    receiptNumber.toString();
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
                                            receiptNumber = int.parse(value);
                                          });
                                        },
                                        controller: voucherSaleNumber,
                                        placeholder: "Receipt Number",
                                      ),
                                    );
                                  });
                            },
                            child: Text(
                              "Receipt No. $receiptNumber",
                              style: GoogleFonts.inter(color: Colors.black),
                            ),
                          );
                        })),
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
                          voucherDateFull = date;
                        });
                      }
                    },
                    child: Text(
                      "${dateformat.format(voucherDateFull)}",
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
                                    focus: voucherclientNameNode,
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
                            Container(
                              padding: const EdgeInsets.only(right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Party Balance: ",
                                      style: GoogleFonts.inter()),
                                  SizedBox(
                                      width: 100,
                                      child: Text(
                                        "₹ $existingCl",
                                        textAlign: TextAlign.end,
                                        style: GoogleFonts.inter(
                                            color: Colors.green.shade600,
                                            fontWeight: FontWeight.bold),
                                      ))
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10, top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Received : ",
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: CTextField(
                                      controller: receivedController,
                                      onTextChanged: (value) {
                                        setState(() {
                                          receivedAmount = value;
                                        });
                                      },
                                      widgetPrefix: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.indigo.shade600,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(7),
                                                    bottomRight:
                                                        Radius.circular(7))),
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
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total ",
                                    style: GoogleFonts.inter(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "₹ $receivedAmount",
                                    style: GoogleFonts.inter(
                                        decoration: TextDecoration.underline,
                                        decorationStyle:
                                            TextDecorationStyle.dashed,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Payment Method : ",
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold),
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
                            Container(
                              height: 100,
                              padding: const EdgeInsets.all(10),
                              child: CupertinoTextField(
                                controller: descriptionController,
                                maxLines: 7,
                                padding: const EdgeInsets.all(10),
                                placeholder: "Description",
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              height: 300,
                            )
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
                                          _clientID = "${e.id}";
                                          existingCl =
                                              double.parse("${e['closing']}");
                                        });
                                        _numberfocus.requestFocus();
                                      },
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Column(
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
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            "₹ ${e['closing']}",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
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
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 30,
        color: Colors.white,
        child: Container(
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: TextButton(
                    onPressed: () {
                      saveRecipt().then((value) {
                        updateClosingBal(_clientID, existingCl);
                        setState(() {
                          voucherCustomerName.clear();
                          voucherCustomerContact.clear();
                          receivedController.clear();
                          receivedAmount = "";
                        });
                        voucherclientNameNode.requestFocus();
                        updateReceipt();
                      });
                    },
                    child: Text(
                      "Save & New",
                      style: GoogleFonts.inter(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.indigo.shade800,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onPressed: () {
                      saveRecipt().then((value) {
                        updateClosingBal(_clientID, existingCl);
                        setState(() {
                          voucherCustomerName.clear();
                          voucherCustomerContact.clear();
                          receivedController.clear();
                          receivedAmount = "";
                        });
                        voucherclientNameNode.requestFocus();
                        updateReceipt();
                        Navigator.pop(context);
                      });
                    },
                    child: Text(
                      "Save",
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  icon: const Icon(Icons.whatsapp),
                  onPressed: () {
                    saveRecipt().then((value) async {
                      updateClosingBal(_clientID, existingCl);
                      updateReceipt();

                      String istring =
                          "Amount Recieved : ${receivedController.text}";
                      String whatsapptext =
                          "Hey!! Here's your Receipt ${voucherCustomerName.text}, created on *${dateformat.format(voucherDateFull)}*\n\n"
                          "-----------------------------------------------------\n$istring\n-----------------------------------------------------\n\n"
                          "*Outstanding: ₹ ${existingCl - double.parse(receivedController.text)}* \n\n"
                          "Thanks for visiting *Chapters of Diet*!";
                      final whatsapplink = WhatsAppUnilink(
                          phoneNumber: "+91${voucherCustomerContact.text}",
                          text: whatsapptext);
                      // ignore: deprecated_member_use
                      await launch('$whatsapplink');
                      Navigator.pop(context);
                      setState(() {
                        voucherCustomerName.clear();
                        voucherCustomerContact.clear();
                        receivedController.clear();
                        receivedAmount = "";
                      });
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
