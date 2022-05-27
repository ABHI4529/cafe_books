import 'package:cafe_books/component/cmenu.dart';
import 'package:cafe_books/component/ctextfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddItem extends StatefulWidget {
  AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  double top = 100;
  double op = 0;
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
        child: Stack(children: [
          Column(
            children: [
              CTextField(
                placeholder: "Item Name",
              ),
              Row(
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        CTextField(
                          placeholder: "Unit",
                        ),
                        AnimatedContainer(
                          width: 400,
                          height: 300,
                          duration: const Duration(milliseconds: 300),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: CTextField(
                      placeholder: "Price",
                    ),
                  ),
                ],
              )
            ],
          ),
        ]),
      ),
    );
  }
}
