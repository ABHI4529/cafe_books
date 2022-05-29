import 'package:cafe_books/component/ctextfield.dart';
import 'package:cafe_books/component/usnackbar.dart';
import 'package:cafe_books/screens/items/items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'additem.dart';

class ItemEdit extends StatefulWidget {
  String itemName;
  String itemPrice;
  String itemDescription;
  String itemId;
  ItemEdit(
      {Key? key,
      required this.itemName,
      required this.itemId,
      required this.itemDescription,
      required this.itemPrice})
      : super(key: key);

  @override
  State<ItemEdit> createState() => _ItemEditState();
}

final TextEditingController _itemNameController = TextEditingController();
final TextEditingController _itemPriceController = TextEditingController();
final TextEditingController _itemDescriptionController =
    TextEditingController();

class _ItemEditState extends State<ItemEdit> {
  final units = ["Nos", "Box", "Kg", "Gm"];
  double top = 100;
  double op = 0;
  TextEditingController unitController = TextEditingController();
  Future saveItem() async {
    itemCollectionRef.doc(widget.itemId).set({
      "itemName": _itemNameController.text,
      "itemPrice": _itemPriceController.text,
      "itemDescription": _itemDescriptionController.text,
      "itemCreatedDate": DateTime.now()
    });
  }

  @override
  void initState() {
    _itemNameController.text = widget.itemName;
    _itemPriceController.text = widget.itemPrice;
    _itemDescriptionController.text = widget.itemDescription;
    super.initState();
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
          "Item Alteration",
          style: GoogleFonts.inter(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          CTextField(
            controller: _itemNameController,
            placeholder: "Item Name",
          ),
          CTextField(
            textInputType: TextInputType.number,
            controller: _itemPriceController,
            placeholder: "Price",
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
                      message: "Item Updated Succesfully",
                      color: const Color(0xff1A659E),
                    ));
                    itemNameController.clear();
                    itemPriceController.clear();
                    itemDescriptionController.clear();

                    Navigator.pop(context);
                  });
                },
                child: Text(
                  "Update",
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
