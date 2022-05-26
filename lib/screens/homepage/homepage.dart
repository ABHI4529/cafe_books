import 'package:cafe_books/component/cmenu.dart';
import 'package:cafe_books/component/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xffDCDCDC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
            "Abhinav Gadekar",
            style: GoogleFonts.inter(
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu_outlined, color: Colors.black),
          onPressed: (){
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawer: const CDrawer(),
      floatingActionButton: const CMenu()
    );
  }
}
