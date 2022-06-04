import 'package:cafe_books/screens/homepage/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'addstockitems.dart';

class Stock extends StatefulWidget {
  Stock({Key? key}) : super(key: key);

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  final PageController _stockController = PageController(initialPage: 0);
  Color textColor1 = Colors.blue.shade900;
  Color textColor2 = Colors.grey;
  final _stockRef = FirebaseFirestore.instance
      .collection("book_data")
      .doc("${user?.email}")
      .collection('stock');
  final _stockitemsRef = FirebaseFirestore.instance
      .collection("book_data")
      .doc("${user?.email}")
      .collection('stockitems');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.chevronLeft),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Stock",
          style: GoogleFonts.inter(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(10),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddStockItem()));
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                primary: const Color(0xff1A659E),
                backgroundColor: Colors.white.withOpacity(0.8),
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
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    _stockController.animateToPage(0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.decelerate);
                  },
                  child: Text(
                    "Stock Transaction",
                    style: GoogleFonts.inter(color: textColor1),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    _stockController.animateToPage(1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.decelerate);
                  },
                  child: Text(
                    "Stock Items",
                    style: GoogleFonts.inter(color: textColor2),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: PageView(
              controller: _stockController,
              onPageChanged: (page) {
                switch (page) {
                  case 0:
                    setState(() {
                      textColor1 = Colors.indigo.shade900;
                      textColor2 = Colors.grey;
                    });
                    break;
                  case 1:
                    setState(() {
                      textColor1 = Colors.grey;
                      textColor2 = Colors.indigo.shade900;
                    });
                }
              },
              children: [
                stocktransactions(stockRef: _stockRef),
                stockItems(stockitemsRef: _stockitemsRef)
              ],
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 130,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              primary: Colors.indigo.shade900,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.add_circle,
                color: Colors.white,
              ),
              Text(
                "Stock",
                style: GoogleFonts.inter(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class stockItems extends StatelessWidget {
  const stockItems({
    Key? key,
    required CollectionReference<Map<String, dynamic>> stockitemsRef,
  })  : _stockitemsRef = stockitemsRef,
        super(key: key);

  final CollectionReference<Map<String, dynamic>> _stockitemsRef;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stockitemsRef.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return ListTile();
          },
        );
      },
    );
  }
}

class stocktransactions extends StatelessWidget {
  const stocktransactions({
    Key? key,
    required CollectionReference<Map<String, dynamic>> stockRef,
  })  : _stockRef = stockRef,
        super(key: key);

  final CollectionReference<Map<String, dynamic>> _stockRef;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stockRef.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "Start Adding Some Data\n",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return ListTile();
          },
        );
      },
    );
  }
}
