import 'package:cafe_books/component/selectclip.dart';
import 'package:cafe_books/component/usnackbar.dart';
import 'package:cafe_books/firebase_options.dart';
import 'package:cafe_books/screens/auth/social-auth.dart';
import 'package:cafe_books/screens/homepage/homepage.dart';
import 'package:cafe_books/screens/users/userScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  runApp(const MaterialApp(
    home: Login(),
    debugShowCheckedModeBanner: false,
  ));
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        backgroundColor: const Color(0xffDCDCDC),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style: GoogleFonts.inter(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: CupertinoTextField(
                        padding: const EdgeInsets.all(10),
                        placeholder: "Email",
                        style: GoogleFonts.inter(),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: CupertinoTextField(
                        padding: const EdgeInsets.all(10),
                        placeholder: "Password",
                        obscureText: true,
                        style: GoogleFonts.inter(),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 30),
                      child: SizedBox(
                        width: 200,
                        child: FutureBuilder(
                            future: Firebase.initializeApp(
                                options:
                                    DefaultFirebaseOptions.currentPlatform),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                print(snapshot.data);
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (snapshot.hasError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    USnackbar(
                                        message: snapshot.error.toString()));
                              }
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: const Color(0xff001F54)),
                                child: Text("Login",
                                    style:
                                        GoogleFonts.inter(color: Colors.white)),
                                onPressed: () {},
                              );
                            }),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sign Up",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: CupertinoTextField(
                        padding: const EdgeInsets.all(10),
                        placeholder: "Contact Number",
                        style: GoogleFonts.inter(),
                      ),
                    ),
                    Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: const Color(0xff001F54)),
                          child: Text(
                            "Send OTP",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {},
                        )),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: const Color(0xff001F54)),
                                  child: Text(
                                    "Google",
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () async {
                                    await FirebaseServices().signInWithGoogle();
                                    setState(() {
                                      user = FirebaseAuth.instance.currentUser;
                                    });
                                  })),
                          Container(
                            width: 10,
                          ),
                          Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: const Color(0xff001F54)),
                                  child: Text(
                                    "Facebook",
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {}))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
      );
    } else {
      return const HomePage();
    }
  }
}
