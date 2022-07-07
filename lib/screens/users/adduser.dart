import 'package:cafe_books/component/ctextfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../homepage/homepage.dart';

class AddUser extends StatefulWidget {
  AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  bool sale = false;
  bool kitchen = false;
  bool stock = false;
  bool expense = false;
  final _userReference = FirebaseFirestore.instance
      .collection("book_data")
      .doc("${user!.email}")
      .collection("users");
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _userPassword = TextEditingController();
  Future _saveUser() async {
    _userReference.doc().set({
      "userName": _userName.text,
      "userPassword": _userPassword.text,
      "isSale": sale,
      "isKitchen": kitchen,
      "isExpense": expense,
      "isStock": stock,
      "owner": user!.email,
      "dateCreate": DateTime.now()
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
            "Add User",
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.bold),
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CTextField(
              placeholder: "User Name",
              controller: _userName,
            ),
            CTextField(
              placeholder: "User Password",
              controller: _userPassword,
            ),
            SwitchListTile(
              activeColor: Colors.indigo.shade700,
              value: sale,
              onChanged: (value) {
                setState(() {
                  sale = value;
                });
              },
              title: Text("Sale",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            ),
            SwitchListTile(
              activeColor: Colors.indigo.shade700,
              value: kitchen,
              onChanged: (value) {
                setState(() {
                  kitchen = value;
                });
              },
              title: Text("Kitchen",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            ),
            SwitchListTile(
              activeColor: Colors.indigo.shade700,
              value: stock,
              onChanged: (value) {
                setState(() {
                  stock = value;
                });
              },
              title: Text("Stock",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            ),
            SwitchListTile(
              activeColor: Colors.indigo.shade700,
              value: expense,
              onChanged: (value) {
                setState(() {
                  expense = value;
                });
              },
              title: Text("Expense",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 5)
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
                      "Save & New",
                      style: GoogleFonts.inter(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.indigo.shade700),
                    onPressed: () {
                      _saveUser().then((value) => Navigator.pop(context));
                    },
                    child: Text(
                      "Save",
                      style: GoogleFonts.inter(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
