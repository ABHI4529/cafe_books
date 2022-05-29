import 'package:cafe_books/component/drawer.dart';
import 'package:cafe_books/screens/homepage/homepage.dart';
import 'package:cafe_books/screens/items/additem.dart';
import 'package:cafe_books/screens/items/itemdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../component/cmenu.dart';

class Items extends StatefulWidget {
  Items({Key? key}) : super(key: key);

  @override
  State<Items> createState() => _ItemsState();
}

GlobalKey<ScaffoldState> itemkey = GlobalKey<ScaffoldState>();

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: itemkey,
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
          "Items",
          style: GoogleFonts.inter(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(10),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => AddItem()));
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                primary: const Color(0xff1A659E),
                backgroundColor: const Color(0xff1A659E).withOpacity(0.2),
              ),
              child: Row(
                children: [
                  Text(
                    "Add Item  ",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xff1A659E),
                    ),
                  ),
                  const Icon(
                    Icons.add,
                    color: Color(0xff1A659E),
                    size: 20,
                  )
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: const CMenu(),
      body: StreamBuilder(
        stream: itemCollectionRef.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  "${snapshot.data?.docs[index]['itemName']}",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return itemDetails(
                          itemId: "${snapshot.data?.docs[index].id}",
                          itemDescription:
                              "${snapshot.data?.docs[index]['itemDescription']}",
                          itemName: "${snapshot.data?.docs[index]['itemName']}",
                          itemPrice:
                              "₹  ${snapshot.data?.docs[index]['itemPrice']}",
                        );
                      });
                },
                shape: const Border(bottom: BorderSide(color: Colors.grey)),
                trailing: Text(
                  "₹  ${snapshot.data?.docs[index]['itemPrice']}",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
