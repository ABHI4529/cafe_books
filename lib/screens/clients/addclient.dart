import 'package:cafe_books/component/ctextfield.dart';
import 'package:cafe_books/component/usnackbar.dart';
import 'package:cafe_books/screens/homepage/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class AddClient extends StatefulWidget {
  AddClient({Key? key}) : super(key: key);

  @override
  State<AddClient> createState() => _AddClientState();
}

final clientCollectionRef = FirebaseFirestore.instance
    .collection("book_data")
    .doc("${user?.email}")
    .collection("clients");

final clientNameController = TextEditingController();
final clientContactController = TextEditingController();
final clientBalanceController = TextEditingController();

class _AddClientState extends State<AddClient> {
  Future addclient() async {
    clientCollectionRef.doc().set({
      "clientName": clientNameController.text,
      "clientContact": clientContactController.text,
      "clientBalance": clientBalanceController.text,
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
          "Client Creation",
          style: GoogleFonts.inter(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CTextField(
              controller: clientNameController,
              placeholder: "Customer Name",
            ),
            CTextField(
              controller: clientContactController,
              placeholder: "Contact Number",
              textInputType: TextInputType.number,
            ),
            CTextField(
              controller: clientBalanceController,
              placeholder: "Op. Bal",
              textInputType: TextInputType.number,
            ),
            Container(
              margin: const EdgeInsets.only(top: 100),
              child: CupertinoButton(
                color: const Color(0xff1A659E),
                onPressed: () {
                  if (clientBalanceController.text.isEmpty) {
                    setState(() {
                      clientBalanceController.text = "0";
                    });
                  }
                  if (clientNameController.text.isEmpty ||
                      clientContactController.text.characters.length > 10 ||
                      clientContactController.text.characters.length < 10) {
                    ScaffoldMessenger.of(context).showSnackBar(USnackbar(
                      message: "Contact Number Or Name Is Incorrect",
                      color: Colors.red.shade600,
                    ));
                  } else {
                    addclient().then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(USnackbar(
                        message: "Client Added Successfully",
                        color: const Color(0xff1A659E),
                      ));
                      clientNameController.clear();
                      clientContactController.clear();
                      clientBalanceController.clear();
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
