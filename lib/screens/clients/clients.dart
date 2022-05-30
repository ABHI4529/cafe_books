import 'package:cafe_books/component/usnackbar.dart';
import 'package:cafe_books/screens/clients/addclient.dart';
import 'package:cafe_books/screens/clients/editClient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../items/additem.dart';

class Clients extends StatefulWidget {
  Clients({Key? key}) : super(key: key);

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
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
          "Clients",
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
                    CupertinoPageRoute(builder: (context) => AddClient()));
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
                    "Add Client  ",
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
      body: StreamBuilder(
        stream: clientCollectionRef.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xff1A659E),
                  child: Text(
                    snapshot.data!.docs[index]['clientName']
                        .toString()
                        .substring(0, 1),
                    style: GoogleFonts.inter(color: Colors.white),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${snapshot.data?.docs[index]['clientName']}",
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${snapshot.data?.docs[index]['clientContact']}",
                      style: GoogleFonts.inter(
                          fontStyle: FontStyle.italic, fontSize: 10),
                    ),
                  ],
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return clientdetails(snapshot, index);
                      });
                },
                trailing: Container(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.call)),
                      IconButton(
                          onPressed: () async {
                            final link = await WhatsAppUnilink(
                                phoneNumber:
                                    "+91${snapshot.data?.docs[index]['clientContact']}");
                            // ignore: deprecated_member_use
                            await launch('$link');
                          },
                          icon: const Icon(Icons.whatsapp))
                    ],
                  ),
                ),
                shape: const Border(
                    bottom: BorderSide(color: Colors.grey, width: 0.5)),
              );
            },
          );
        },
      ),
    );
  }

  Dialog clientdetails(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 350,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            CircleAvatar(
              radius: 35,
              backgroundColor: const Color(0xff1A659E),
              child: Text(
                snapshot.data!.docs[index]['clientName']
                    .toString()
                    .substring(0, 1),
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30),
              ),
            ),
            Text(
              "${snapshot.data?.docs[index]['clientName']}",
              style: GoogleFonts.inter(fontSize: 20),
            ),
            Text(
              "${snapshot.data?.docs[index]['clientContact']}",
              style: GoogleFonts.inter(fontSize: 13),
            ),
            Text(
              "Balance : ${snapshot.data?.docs[index]['clientBalance']}",
              style: GoogleFonts.inter(fontSize: 13),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      child: Row(
                        children: [
                          Text(
                            "Delete  ",
                            style: GoogleFonts.inter(
                                color: Colors.red.shade700, fontSize: 13),
                          ),
                          Icon(
                            Icons.delete,
                            color: Colors.red.shade700,
                          )
                        ],
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "Delete ${snapshot.data?.docs[index]['clientName']} ?",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                actionsAlignment: MainAxisAlignment.spaceEvenly,
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Cancle",
                                      style: GoogleFonts.inter(),
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        clientCollectionRef
                                            .doc(snapshot.data?.docs[index].id)
                                            .delete()
                                            .then((value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(USnackbar(
                                                  message: "Cient Deleted"));
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Text(
                                        "Delete",
                                        style: GoogleFonts.inter(
                                            color: Colors.red.shade700),
                                      ))
                                ],
                              );
                            });
                      }),
                  SizedBox(
                    width: 130,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xff1A659E)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Edit  ",
                              style: GoogleFonts.inter(
                                  color: Colors.white, fontSize: 13),
                            ),
                            const Icon(Icons.edit, color: Colors.white)
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => EditClient(
                                      clientId:
                                          "${snapshot.data?.docs[index].id}",
                                      clientContact:
                                          "${snapshot.data?.docs[index]['clientContact']}",
                                      clientBalance:
                                          "${snapshot.data?.docs[index]['clientBalance']}",
                                      clientName:
                                          "${snapshot.data?.docs[index]['clientName']}"))));
                        }),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
