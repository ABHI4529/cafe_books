import 'package:cafe_books/component/ctextfield.dart';
import 'package:cafe_books/component/usnackbar.dart';
import 'package:cafe_books/screens/homepage/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class EditStockItem extends StatefulWidget {
  String? itemID;
  String? itemName;
  String? itemPrice;
  String? itemUnit;
  int? opBal;
  String? description;
  EditStockItem(
      {Key? key,
      this.itemID,
      this.itemName,
      this.itemPrice,
      this.itemUnit,
      this.description,
      this.opBal})
      : super(key: key);

  @override
  State<EditStockItem> createState() => _EditStockItemState();
}

class _EditStockItemState extends State<EditStockItem> {
  double _top = -500;
  double width = 0;
  final GlobalKey _unitKey = GlobalKey();
  List _filterunitlist = [];
  final FocusNode _pricNode = FocusNode();
  final _searchText = "";
  final List _unitList = [
    "Nos",
    "Bag",
    "Pac",
    "Kg",
    "Gm",
    "Lt",
    "Can",
    "Doz",
    "Tin",
    "Rol",
    "Set"
  ];

  final _stockItemName = TextEditingController();
  final _stockItemUnit = TextEditingController();
  final _stockItemPrice = TextEditingController();
  final _stockItemBal = TextEditingController();
  final _stockItemDescription = TextEditingController();
  final _itemNameNode = FocusNode();

  final CollectionReference _stockRef = FirebaseFirestore.instance
      .collection('book_data')
      .doc("${user?.email}")
      .collection("stock");

  Future saveStock() async {
    await _stockRef.doc(widget.itemID).update({
      "stockItemName": _stockItemName.text,
      "stockItemUnit": _stockItemUnit.text,
      "stockItemPrice": double.parse(_stockItemPrice.text),
      "stockItemBal": int.parse(_stockItemBal.text),
      "stockItemClosing": int.parse(_stockItemBal.text),
      "stockItemDescription": _stockItemDescription.text,
      "stockItemCreation": DateTime.now()
    });
  }

  Future deleteItem() async {
    _stockRef.doc(widget.itemID).delete();
  }

  @override
  void initState() {
    setState(() {
      _stockItemName.text = widget.itemName!;
      _stockItemBal.text = widget.opBal.toString();
      _stockItemDescription.text = widget.description!;
      _stockItemUnit.text = widget.itemUnit!;
      _stockItemPrice.text = widget.itemPrice!;
      _filterunitlist = _unitList;
    });
    super.initState();
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
            "Add Stock Item",
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.bold),
          )),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CTextField(
                    controller: _stockItemName,
                    focus: _itemNameNode,
                    placeholder: "Item Name",
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Focus(
                          onFocusChange: (focus) {
                            RenderBox renderBox = _unitKey.currentContext!
                                .findRenderObject() as RenderBox;
                            if (focus) {
                              setState(() {
                                _top = renderBox.localToGlobal(Offset.zero).dy -
                                    25;
                                width = renderBox.size.width;
                              });
                            } else {
                              setState(() {
                                _top = -500;
                                width = 0;
                              });
                            }
                          },
                          child: CTextField(
                            onTextChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  _filterunitlist = _unitList;
                                });
                              } else {
                                setState(() {
                                  _filterunitlist = _unitList
                                      .where((element) => element
                                          .toString()
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList();
                                });
                              }
                            },
                            controller: _stockItemUnit,
                            key: _unitKey,
                            placeholder: "Unit",
                          ),
                        ),
                      ),
                      Expanded(
                        child: CTextField(
                          controller: _stockItemPrice,
                          textInputType: TextInputType.number,
                          focus: _pricNode,
                          placeholder: "Price",
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: CTextField(
                          controller: _stockItemBal,
                          textInputType: TextInputType.number,
                          placeholder: "Op. Bal",
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    height: 100,
                    child: CupertinoTextField(
                      controller: _stockItemDescription,
                      placeholder: "Description",
                      maxLines: 5,
                      style: GoogleFonts.inter(),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: _top,
            left: 10,
            child: Container(
              width: width,
              height: 200,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 10)
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Unit",
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: _filterunitlist
                          .map((e) => ListTile(
                                onTap: () {
                                  setState(() {
                                    _stockItemUnit.text = e;
                                  });
                                  _pricNode.requestFocus();
                                },
                                title: Text(e, style: GoogleFonts.inter()),
                              ))
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      bottomSheet: BottomAppBar(
        elevation: 5,
        child: Container(
          height: 60,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 4)
          ]),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: TextButton(
                    onPressed: () {
                      deleteItem().then((value) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            USnackbar(message: "Stock Item Deleted"));
                      });
                    },
                    child: Text(
                      'Delete',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        primary: Colors.indigo.shade700),
                    onPressed: () {
                      if (_stockItemBal.text.isEmpty) {
                        setState(() {
                          _stockItemBal.text = "0";
                        });
                      }
                      saveStock().then((value) {
                        setState(() {
                          _stockItemName.clear();
                          _stockItemUnit.clear();
                          _stockItemPrice.clear();
                          _stockItemBal.clear();
                          _stockItemDescription.clear();
                        });
                        Navigator.pop(context);
                      });
                    },
                    child: Text(
                      'Save',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
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
