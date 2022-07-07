import 'package:cafe_books/component/ctextfield.dart';
import 'package:cafe_books/component/usnackbar.dart';
import 'package:cafe_books/screens/users/userDashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../homepage/homepage.dart';

class UserScreen extends StatefulWidget {
  UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

String userName = "";

class _UserScreenState extends State<UserScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _obsure = true;
  final _userReference = FirebaseFirestore.instance
      .collection("book_data")
      .doc("${user!.email}")
      .collection("users");
  Future credentials() async {
    QuerySnapshot querySnapshot =
        await _userReference.where("userName", isEqualTo: _username.text).get();
    if (querySnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          USnackbar(message: "User Name Or Password is Incorrect"));
    }
    querySnapshot.docs.forEach((e) {
      if (e['userPassword'] == _password.text) {
        setState(() {
          userName = _username.text;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UserDashboard()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            USnackbar(message: "User Name Or Password is Incorrect"));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Login",
                      style: GoogleFonts.inter(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  CTextField(placeholder: "User Name", controller: _username),
                  CTextField(
                    placeholder: "Password",
                    controller: _password,
                    obscure: _obsure,
                    widgetPrefix: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.indigo.shade700,
                      ),
                      onPressed: () {
                        setState(() {
                          _obsure = !_obsure;
                        });
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 50),
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.indigo.shade700),
                        child: Text("Login",
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          credentials();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
