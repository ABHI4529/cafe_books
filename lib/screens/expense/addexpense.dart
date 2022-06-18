import 'package:cafe_books/component/ctextfield.dart';
import 'package:cafe_books/component/usnackbar.dart';
import 'package:cafe_books/screens/homepage/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class AddExpense extends StatefulWidget {
  AddExpense({Key? key}) : super(key: key);

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

final expenseCollectionRef = FirebaseFirestore.instance
    .collection("book_data")
    .doc("${user?.email}")
    .collection("expenses");

final expenseNameController = TextEditingController();
final expenseAmoutController = TextEditingController();

class _AddExpenseState extends State<AddExpense> {
  Future addexpense() async {
    expenseCollectionRef.doc().set({
      "expName": expenseNameController.text,
      "expAmount": expenseAmoutController.text,
      "dateCreated": DateTime.now()
    });
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
          "Expense Creation",
          style: GoogleFonts.inter(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CTextField(
              controller: expenseNameController,
              placeholder: "Expense Name",
            ),
            CTextField(
              textInputType: TextInputType.number,
              controller: expenseAmoutController,
              placeholder: "Amount",
            ),
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: CupertinoButton(
                color: const Color(0xff1A659E),
                onPressed: () {
                  if (expenseAmoutController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(USnackbar(
                      message: "Expense Name Required",
                      color: Colors.red.shade700,
                    ));
                  } else {
                    addexpense().then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(USnackbar(
                        message: "Expense Created",
                        color: const Color(0xff1A659E),
                      ));
                      expenseNameController.clear();
                      expenseAmoutController.clear();
                    });
                  }
                },
                child: Text(
                  "Save",
                  style: GoogleFonts.inter(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
