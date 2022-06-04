import 'package:cafe_books/component/cmenu.dart';
import 'package:cafe_books/component/ctextfield.dart';
import 'package:cafe_books/component/stextfield.dart';
import 'package:cafe_books/component/usnackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:searchfield/searchfield.dart';
import 'package:textfield_search/textfield_search.dart';

class AddItem extends StatefulWidget {
  AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

final TextEditingController itemNameController = TextEditingController();
final TextEditingController itemPriceController = TextEditingController();
final TextEditingController itemUnitController = TextEditingController();
final TextEditingController itemDescriptionController = TextEditingController();

final itemCollectionRef = FirebaseFirestore.instance
    .collection("book_data")
    .doc("abhinavgadekar4529@gmail.com")
    .collection("items");

class _AddItemState extends State<AddItem> {
  final units = ["Nos", "Box", "Kg", "Gm"];
  double top = 100;
  double op = 0;
  TextEditingController unitController = TextEditingController();
  Future saveItem() async {
    itemCollectionRef.doc().set({
      "itemName": itemNameController.text,
      "itemPrice": itemPriceController.text,
      "itemUnit": itemUnitController.text,
      "itemDescription": itemDescriptionController.text,
      "itemCreatedDate": DateTime.now()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          "Item Creation",
          style: GoogleFonts.inter(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          CTextField(
            controller: itemNameController,
            placeholder: "Item Name",
          ),
          Row(
            children: [
              Expanded(
                  child: DSearchField(
                controller: itemUnitController,
                label: "Unit",
                list: units,
              )),
              Expanded(
                child: CTextField(
                  textInputType: TextInputType.number,
                  controller: itemPriceController,
                  placeholder: "Price",
                ),
              ),
            ],
          ),
          Container(
            height: 100,
            padding: const EdgeInsets.all(10),
            child: CupertinoTextField(
                controller: itemDescriptionController,
                placeholder: "Description",
                maxLength: 5,
                padding: const EdgeInsets.all(10),
                style: GoogleFonts.inter()),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(top: 100),
            child: SizedBox(
              child: CupertinoButton(
                color: const Color(0xff1A659E),
                onPressed: () {
                  saveItem().then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(USnackbar(
                      message: "Item Created Succesfully",
                      color: const Color(0xff1A659E),
                    ));
                    itemNameController.clear();
                    itemUnitController.clear();
                    itemPriceController.clear();
                    itemDescriptionController.clear();
                  });
                },
                child: Text(
                  "Save",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
