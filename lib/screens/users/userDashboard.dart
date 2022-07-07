import 'package:cafe_books/component/usnackbar.dart';
import 'package:cafe_books/screens/expense/expense.dart';
import 'package:cafe_books/screens/kitchen/kitchen.dart';
import 'package:cafe_books/screens/sale/sale.dart';
import 'package:cafe_books/screens/stock/stock.dart';
import 'package:cafe_books/screens/users/userScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../homepage/homepage.dart';

class UserDashboard extends StatefulWidget {
  UserDashboard({Key? key}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final _userReference = FirebaseFirestore.instance
      .collection("book_data")
      .doc("${user!.email}")
      .collection("users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.indigo.shade700,
          title: Text("$userName's Dashboard"),
        ),
        body: StreamBuilder(
            stream: _userReference.where(userName).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: [
                    ListTile(
                      title: Text("Sale Voucher",
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.bold)),
                      onTap: () {
                        snapshot.data?.docs.forEach((e) {
                          if (e['isSale'] == true) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Sale()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                USnackbar(message: "No Access Granted"));
                          }
                        });
                      },
                      trailing: Icon(
                        FontAwesomeIcons.fileInvoice,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        snapshot.data?.docs.forEach((e) {
                          if (e['isStock'] == true) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Stock()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                USnackbar(message: "No Access Granted"));
                          }
                        });
                      },
                      title: Text("Stock",
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.bold)),
                      trailing: Icon(
                        FontAwesomeIcons.boxOpen,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        snapshot.data?.docs.forEach((e) {
                          if (e['isExpense'] == true) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Expense()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                USnackbar(message: "No Access Granted"));
                          }
                        });
                      },
                      title: Text("Expense",
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.bold)),
                      trailing: Icon(
                        FontAwesomeIcons.wallet,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        snapshot.data?.docs.forEach((e) {
                          if (e['isKitchen'] == true) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Kitchen()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                USnackbar(message: "No Access Granted"));
                          }
                        });
                      },
                      title: Text("Kitchen",
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.bold)),
                      trailing: Icon(
                        FontAwesomeIcons.utensils,
                        color: Colors.indigo.shade700,
                      ),
                    )
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
