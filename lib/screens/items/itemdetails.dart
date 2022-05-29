import 'package:cafe_books/screens/items/additem.dart';
import 'package:cafe_books/screens/items/itemEdit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class itemDetails extends StatefulWidget {
  String itemName;
  String itemPrice;
  String itemDescription;
  String itemId;
  itemDetails(
      {Key? key,
      required this.itemName,
      required this.itemId,
      required this.itemPrice,
      required this.itemDescription})
      : super(key: key);

  @override
  State<itemDetails> createState() => _itemDetailsState();
}

class _itemDetailsState extends State<itemDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 10,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(50)),
          ),
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.itemName,
                  style: GoogleFonts.inter(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Container(
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: Container(
                                      height: 250,
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "Delete ${widget.itemName} ?",
                                            style: GoogleFonts.inter(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "Cancle",
                                                      style: GoogleFonts.inter(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: SizedBox(
                                                      width: 140,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                primary:
                                                                    const Color(
                                                                        0xff1A659E)),
                                                        onPressed: () {
                                                          itemCollectionRef
                                                              .doc(
                                                                  widget.itemId)
                                                              .delete()
                                                              .then((value) {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        },
                                                        child: Text(
                                                          "Delete",
                                                          style:
                                                              GoogleFonts.inter(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      )),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ItemEdit(
                                        itemName: widget.itemName,
                                        itemId: widget.itemId,
                                        itemDescription: widget.itemDescription,
                                        itemPrice: widget.itemPrice)));
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Color(0xff1A659E),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 50),
            child: Row(
              children: [
                Text(
                  "Price :",
                  style: GoogleFonts.inter(
                    fontSize: 15,
                  ),
                ),
                Text("  ${widget.itemPrice}",
                    style: GoogleFonts.inter(
                        fontSize: 15, fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  "Description :",
                  style: GoogleFonts.inter(
                    fontSize: 15,
                  ),
                ),
                Text("  ${widget.itemDescription}",
                    style: GoogleFonts.inter(
                        fontSize: 15, fontWeight: FontWeight.bold))
              ],
            ),
          )
        ],
      ),
    );
  }
}
