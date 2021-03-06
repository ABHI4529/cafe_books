import 'dart:convert';

import 'package:cafe_books/screens/receipt/recipt.dart';
import 'package:cafe_books/screens/sale/sale.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import '../../datautil/saledatahandler.dart';
import '../homepage/homepage.dart';
import 'editsalevoucher.dart';

class SaleView extends StatefulWidget {
  SaleView({Key? key}) : super(key: key);
  @override
  State<SaleView> createState() => _SaleViewState();
}

class _SaleViewState extends State<SaleView> {
  DateFormat dateformat = DateFormat("dd - MMMM - yyyy");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.indigo.shade800,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(FontAwesomeIcons.chevronLeft),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Receipt()));
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  primary: Colors.white.withOpacity(0.6),
                  backgroundColor: Colors.white.withOpacity(0.6),
                ),
                child: Row(
                  children: [
                    Text(
                      "Add Receipt  ",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.indigo.shade800,
                      ),
                    ),
                    Icon(
                      Icons.add,
                      color: Colors.indigo.shade800,
                      size: 20,
                    )
                  ],
                ),
              ),
            )
          ],
          title: Text(
            "Sales",
            style: GoogleFonts.inter(color: Colors.white),
          )),
      body: StreamBuilder(
          stream: saleCollection
              .where("voucherType", isEqualTo: "Sale")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            List<double> totalSale = [];

            snapshot.data!.docs.forEach((e) {
              totalSale.add(double.parse(e['totalSale'].toString()));
            });

            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5), blurRadius: 10)
                    ],
                    color: Colors.indigo.shade800,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Sale",
                          style: GoogleFonts.inter(color: Colors.white)),
                      Text(
                        "??? ${totalSale.sum}",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    Timestamp t = snapshot.data?.docs[index]['date'];
                    DateTime d = t.toDate();
                    List items = snapshot.data!.docs[index]['Items'];

                    List<SaleHandler> edititems = List<SaleHandler>.from(
                        items.map((e) => SaleHandler.fromJson(e)));

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditSale(
                                      totalAmountReceived: snapshot
                                          .data?.docs[index]['amountRecevied'],
                                      orderNumber: snapshot.data?.docs[index]
                                          ['orderNumber'],
                                      totaldiscount: snapshot.data?.docs[index]
                                          ['discount'],
                                      edititems: edititems,
                                      customerName: snapshot.data?.docs[index]
                                          ['customerName'],
                                      docid: snapshot.data?.docs[index].id,
                                      value: snapshot.data?.docs[index]
                                          ['paymentMethod'],
                                      voucherSaleNumber: snapshot
                                          .data?.docs[index]['saleNumber'],
                                      voucherDate: d,
                                      customerContact: snapshot
                                          .data?.docs[index]['customerContact'],
                                    )));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${snapshot.data!.docs[index]['customerName']}",
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    "Invoice # ${snapshot.data!.docs[index]['saleNumber']}")
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Payment Method : ${snapshot.data!.docs[index]['paymentMethod']}",
                                    style: GoogleFonts.inter(),
                                  ),
                                  Text(
                                    "${dateformat.format(d)}",
                                    style: GoogleFonts.inter(),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "??? ${snapshot.data!.docs[index]['totalSale']}",
                                  style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditSale(
                                                          totalAmountReceived:
                                                              snapshot.data
                                                                          ?.docs[
                                                                      index][
                                                                  'amountRecevied'],
                                                          orderNumber: snapshot
                                                                  .data
                                                                  ?.docs[index]
                                                              ['orderNumber'],
                                                          totaldiscount: snapshot
                                                                  .data
                                                                  ?.docs[index]
                                                              ['discount'],
                                                          edititems: edititems,
                                                          customerName: snapshot
                                                                  .data
                                                                  ?.docs[index]
                                                              ['customerName'],
                                                          docid: snapshot.data
                                                              ?.docs[index].id,
                                                          value: snapshot.data
                                                                  ?.docs[index]
                                                              ['paymentMethod'],
                                                          voucherSaleNumber:
                                                              snapshot.data
                                                                          ?.docs[
                                                                      index][
                                                                  'saleNumber'],
                                                          voucherDate: d,
                                                          customerContact: snapshot
                                                                  .data
                                                                  ?.docs[index][
                                                              'customerContact'],
                                                        )));
                                          },
                                          icon: const Icon(Icons.whatsapp)),
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.call)),
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.print)),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ))
              ],
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 120,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              primary: Colors.indigo.shade900),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Sale()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.add_circle,
                color: Colors.white,
              ),
              Text(
                " Sale",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
