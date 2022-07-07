import 'package:cafe_books/screens/homepage/homepage.dart';
import 'package:cafe_books/screens/users/adduser.dart';
import 'package:cafe_books/screens/users/userScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettings extends StatefulWidget {
  UserSettings({Key? key}) : super(key: key);

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  final _userReference = FirebaseFirestore.instance
      .collection("book_data")
      .doc("${user!.email}")
      .collection("users");
  Future setUpUserDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("user", true);
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
          "Users",
          style: GoogleFonts.inter(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              CupertinoIcons.settings,
              color: Colors.black,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: StreamBuilder(
        stream: _userReference.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                  child: Text(
                "No Users Found",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ));
            } else {
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("${snapshot.data?.docs[index]['userName']}"),
                    onLongPress: () {
                      setUpUserDevice().then((value) =>
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserScreen())));
                    },
                  );
                },
              );
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              CupertinoModalPopupRoute(builder: (context) => AddUser()));
        },
        backgroundColor: Colors.indigo.shade700,
        child: const Icon(Icons.add),
      ),
    );
  }
}
