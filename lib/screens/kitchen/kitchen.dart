import 'package:cafe_books/screens/sale/sale.dart';
import 'package:cafe_books/screens/sale/saleview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Kitchen extends StatefulWidget {
  const Kitchen({Key? key}) : super(key: key);

  @override
  State<Kitchen> createState() => _KitchenState();
}

List completedOrders = [];
List pendingOrders = [];

class _KitchenState extends State<Kitchen> {
  DateTime now = DateTime.now();
  DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
  Timestamp tFrom = Timestamp.now();
  Timestamp tTo = Timestamp.now();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
              "Kitchen",
              style: GoogleFonts.inter(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            bottom: TabBar(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                indicator: BoxDecoration(
                    color: Colors.indigo.shade800,
                    borderRadius: BorderRadius.circular(8)),
                unselectedLabelColor: Colors.black87,
                labelPadding: const EdgeInsets.all(6),
                tabs: [
                  Text(
                    "Queue",
                    style: GoogleFonts.inter(fontSize: 16),
                  ),
                  Text(
                    "Completed",
                    style: GoogleFonts.inter(fontSize: 16),
                  )
                ]),
          ),
          body: const TabBarView(
            children: [
              // Queue
              pendingorder(),
              completedorder(),
            ],
          )),
    );
  }
}

class completedorder extends StatelessWidget {
  const completedorder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: saleCollection
          .where("orderCompleted", isEqualTo: true)
          .where("voucherType", isEqualTo: "Sale")
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            List _itemlist = snapshot.data?.docs[index]['Items'];
            return Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3)),
                        child: Text(
                          "# ${snapshot.data?.docs[index]['orderNumber']}",
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "${snapshot.data?.docs[index]['customerName']}",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey.shade600))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            "Itm Name",
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "Quantity",
                          style: GoogleFonts.inter(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: _itemlist
                        .map((e) => Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${e['itemName']}",
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${e['itemQuantity']}",
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ))
                        .toList(),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class pendingorder extends StatelessWidget {
  const pendingorder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: saleCollection
          .where("orderCompleted", isEqualTo: false)
          .where("voucherType", isEqualTo: "Sale")
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data?.docs.length == 0) {
          return Center(
            child: Text(
              "No Pending Orders",
              style:
                  GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            List _itemlist = snapshot.data?.docs[index]['Items'];
            return GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          height: 200,
                          width: double.maxFinite,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  "Order # ${snapshot.data?.docs[index]['orderNumber']} Completed ?",
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration:
                                    BoxDecoration(color: Colors.grey.shade300),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.grey),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Cancle",
                                          style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.indigo.shade800),
                                        onPressed: () {
                                          saleCollection
                                              .doc(
                                                  snapshot.data?.docs[index].id)
                                              .update({"orderCompleted": true});
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Completed",
                                          style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.indigo.shade900,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3)),
                          child: Text(
                            "# ${snapshot.data?.docs[index]['orderNumber']}",
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "${snapshot.data?.docs[index]['customerName']}",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.blue.shade100))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              "Itm Name",
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            "Quantity",
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: _itemlist
                          .map((e) => Container(
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${e['itemName']}",
                                      style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${e['itemQuantity']}",
                                      style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
