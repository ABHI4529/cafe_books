import 'package:cafe_books/component/ctextfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class AddStockItem extends StatefulWidget {
  AddStockItem({Key? key}) : super(key: key);

  @override
  State<AddStockItem> createState() => _AddStockItemState();
}

class _AddStockItemState extends State<AddStockItem> {
  double _top = -500;
  double width = 0;
  final GlobalKey _unitKey = GlobalKey();
  final _unitController = TextEditingController();
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
  @override
  void initState() {
    setState(() {
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
                            controller: _unitController,
                            key: _unitKey,
                            placeholder: "Unit",
                          ),
                        ),
                      ),
                      Expanded(
                        child: CTextField(
                          focus: _pricNode,
                          placeholder: "Price",
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    height: 100,
                    child: CupertinoTextField(
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
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Unit",
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          child: Text(
                            "Add Unit",
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: _filterunitlist
                          .map((e) => ListTile(
                                onTap: () {
                                  setState(() {
                                    _unitController.text = e;
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
    );
  }
}
