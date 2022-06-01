import 'package:cafe_books/component/usnackbar.dart';
import 'package:cafe_books/screens/expense/addexpense.dart';
import 'package:cafe_books/screens/expense/editexpense.dart';
import 'package:cafe_books/screens/expense/expensevoucher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../items/additem.dart';

class Expense extends StatefulWidget {
  Expense({Key? key}) : super(key: key);

  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  PageController pageController = PageController();
  Color textColor1 = Colors.blue.shade700;
  Color textColor2 = Colors.grey;
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
          "Expenses",
          style: GoogleFonts.inter(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(10),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => AddExpense()));
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                primary: const Color(0xff1A659E),
                backgroundColor: const Color(0xff1A659E).withOpacity(0.2),
              ),
              child: Row(
                children: [
                  Text(
                    "Add ",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xff1A659E),
                    ),
                  ),
                  const Icon(
                    Icons.add,
                    color: Color(0xff1A659E),
                    size: 20,
                  )
                ],
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                    ),
                    onPressed: () {
                      pageController.animateToPage(0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.decelerate);
                    },
                    child: Text("Expense List",
                        style: GoogleFonts.inter(color: textColor1)),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      pageController.animateToPage(1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.decelerate);
                    },
                    child: Text(
                      "Expense Items",
                      style: GoogleFonts.inter(color: textColor2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              onPageChanged: (page) {
                if (page == 0) {
                  setState(() {
                    textColor1 = Colors.blue.shade700;
                    textColor2 = Colors.grey;
                  });
                }
                if (page == 1) {
                  setState(() {
                    textColor1 = Colors.grey;
                    textColor2 = Colors.blue.shade700;
                  });
                }
              },
              controller: pageController,
              children: [
                Container(),
                StreamBuilder(
                  stream: expenseCollectionRef.snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          shape: const Border(
                              bottom:
                                  BorderSide(color: Colors.grey, width: 0.5)),
                          title: Text(
                            "${snapshot.data?.docs[index]['expName']}",
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.bold),
                          ),
                          trailing: Container(
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "₹ ${snapshot.data?.docs[index]['expAmount']}",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold),
                                ),
                                PopupMenuButton(
                                  position: PopupMenuPosition.under,
                                  splashRadius: 50,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      onTap: () {
                                        Future<void>.delayed(
                                            const Duration(),
                                            () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => EditExpense(
                                                        expenseName:
                                                            "${snapshot.data?.docs[index]['expName']}",
                                                        expenseAmount:
                                                            "${snapshot.data?.docs[index]['expAmount']}",
                                                        expenseId:
                                                            "${snapshot.data?.docs[index].id}"))));
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(Icons.edit),
                                          Text("   Edit",
                                              style: GoogleFonts.inter()),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        Future<void>.delayed(
                                            const Duration(),
                                            () => showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      "Delete ${snapshot.data?.docs[index]['expName']} ?",
                                                      style: GoogleFonts.inter(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    actionsAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    actionsPadding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    actions: [
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text("Cancle",
                                                              style: GoogleFonts
                                                                  .inter())),
                                                      TextButton(
                                                        onPressed: () {
                                                          expenseCollectionRef
                                                              .doc(snapshot
                                                                  .data
                                                                  ?.docs[index]
                                                                  .id)
                                                              .delete()
                                                              .then((value) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    USnackbar(
                                                                        message:
                                                                            "Expense Deleted"));
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        },
                                                        child: SizedBox(
                                                          width: 70,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "Delete",
                                                                style: GoogleFonts
                                                                    .inter(
                                                                        color: Colors
                                                                            .red),
                                                              ),
                                                              const Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                }));
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(Icons.delete),
                                          Text("   Delete",
                                              style: GoogleFonts.inter()),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: const Color(0xff1A659E),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => ExpenseVoucer())));
        },
        child: Text(
          "New Expense",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
