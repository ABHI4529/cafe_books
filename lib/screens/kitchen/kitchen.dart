import 'package:cafe_books/screens/sale/sale.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Kitchen extends StatefulWidget {
  const Kitchen({Key? key}) : super(key: key);

  @override
  State<Kitchen> createState() => _KitchenState();
}

class _KitchenState extends State<Kitchen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
            "Kitchen",
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              indicator: BoxDecoration(
                  color: Colors.indigo.shade800,
                  borderRadius: BorderRadius.circular(8)),
              unselectedLabelColor: Colors.black87,
              labelPadding: const EdgeInsets.all(6),
              tabs: [
                Text(
                  "Queue",
                  style: GoogleFonts.inter(fontSize: 16),
                ),
                Text(
                  "Completed",
                  style: GoogleFonts.inter(fontSize: 16),
                )
              ]),
        ),
        body: StreamBuilder(
            stream: saleCollection.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return TabBarView(
                children: [
                  // Queue
                  ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        List items = snapshot.data!.docs[index]['Items'];
                        return GestureDetector(
                          onTap: () {},
                          child: Text(
                              "${snapshot.data?.docs[index]["items"]["itemName"]}"),
                        );
                      }),
                  Text("Completed"),
                ],
              );
            }),
      ),
    );
  }
}
