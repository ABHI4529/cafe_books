import 'package:cafe_books/component/cmenu.dart';
import 'package:cafe_books/component/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../component/selectclip.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

var user = FirebaseAuth.instance.currentUser;

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool page1 = false;
  bool page2 = false;
  bool page3 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xffDCDCDC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "${user?.displayName}",
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu_outlined, color: Colors.black),
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
        drawer: const CDrawer(),
        floatingActionButton: const CMenu(),
        body: Wrap(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(color: Colors.grey, blurRadius: 5)
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(FontAwesomeIcons.fileContract,
                                      color: Colors.blue.shade700),
                                  Text(
                                    "   Sales",
                                    style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  '₹ 0',
                                  style: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(color: Colors.grey, blurRadius: 5)
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(FontAwesomeIcons.wallet,
                                      color: Colors.red.shade700),
                                  Text(
                                    "   Expenses",
                                    style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  '₹ 0',
                                  style: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Select_Clip(
                          title: "Parties",
                          callback: () {
                            setState(() {
                              page1 = true;
                              page2 = false;
                              page3 = false;
                            });
                          },
                          selected: page1,
                        ),
                        Select_Clip(
                          title: "Sales",
                          callback: () {
                            setState(() {
                              page1 = false;
                              page2 = true;
                              page3 = false;
                            });
                          },
                          selected: page2,
                        ),
                        Select_Clip(
                          title: "Transactions",
                          callback: () {
                            setState(() {
                              page1 = false;
                              page2 = false;
                              page3 = true;
                            });
                          },
                          selected: page3,
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
