import 'package:cafe_books/component/cmenu.dart';
import 'package:cafe_books/component/ctextfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:textfield_search/textfield_search.dart';

class AddItem extends StatefulWidget {
  AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final units = ["Nos", "Box", "Kg", "Gm"];
  double top = 100;
  double op = 0;
  TextEditingController unitController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.black)),
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
            placeholder: "Item Name",
          ),
          Row(
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [CTextField()],
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}
