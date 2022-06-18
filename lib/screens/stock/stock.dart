import 'package:cafe_books/datautil/stockvoucherdata.dart';
import 'package:cafe_books/screens/homepage/homepage.dart';
import 'package:cafe_books/screens/stock/editStockTransaction.dart';
import 'package:cafe_books/screens/stock/editvstockitem.dart';
import 'package:cafe_books/screens/stock/stocktransactions.dart';
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
      .collection('book_data')
      .doc("${user?.email}")
      .collection("stock");

  final stockTrnRef = FirebaseFirestore.instance
      .collection("book_data")
      .doc("${user?.email}")
      .collection("stockTranscation")
      .orderBy("stockTrn");

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
                stocktransactions(stockRef: stockTrnRef),
                stockItems(stockitemsRef: _stockRef)
              ],
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 130,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => StockTransaction()));
          },
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
            return ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditStockItem(
                              itemName: snapshot.data?.docs[index]
                                  ['stockItemName'],
                              description: snapshot.data?.docs[index]
                                  ['stockItemDescription'],
                              itemID: snapshot.data?.docs[index].id,
                              itemPrice: snapshot
                                  .data?.docs[index]['stockItemPrice']
                                  .toString(),
                              itemUnit: snapshot.data?.docs[index]
                                  ['stockItemUnit'],
                              opBal: snapshot.data?.docs[index]['stockItemBal'],
                            )));
              },
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${snapshot.data?.docs[index]['stockItemName']}",
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Curr. Bal: ${snapshot.data?.docs[index]['stockItemClosing']}",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              trailing: Text(
                "₹ ${snapshot.data?.docs[index]['stockItemPrice']} / ${snapshot.data?.docs[index]['stockItemUnit']}",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
            );
          },
        );
      },
    );
  }
}

class stocktransactions extends StatelessWidget {
  stocktransactions({
    Key? key,
    required this.stockRef,
  }) : super(key: key);

  final stockRef;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stockRef.snapshots(),
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
            List items = snapshot.data!.docs[index]['stockItems'];
            return TransactionCard(
              isPurchase: snapshot.data!.docs[index]['purchase'],
              items: items,
              index: index,
              snapshot: snapshot,
            );
          },
        );
      },
    );
  }
}

class TransactionCard extends StatefulWidget {
  TransactionCard(
      {Key? key,
      required this.index,
      required this.items,
      this.snapshot,
      required this.isPurchase})
      : super(key: key);

  final List items;
  final int index;
  final AsyncSnapshot<QuerySnapshot>? snapshot;
  bool isPurchase;

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  Color cardColor = Colors.indigo.shade200;
  @override
  void initState() {
    if (widget.isPurchase) {
      setState(() {
        cardColor = Colors.indigo;
      });
    } else {
      setState(() {
        cardColor = Colors.red.shade700;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        List items = widget.snapshot!.data?.docs[widget.index]['stockItems'];
        List<StockItem> stockItemList =
            List<StockItem>.from(items.map((e) => StockItem.fromJson(e)));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditStockTransaction(
                      itemList: stockItemList,
                      isPurchase: widget.snapshot?.data?.docs[widget.index]
                          ['purchase'],
                      trnID: widget.snapshot?.data?.docs[widget.index].id,
                      trnNo: widget.snapshot?.data?.docs[widget.index]
                          ['stockTrn'],
                    )));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(3)),
              child: Text(
                "# ${widget.snapshot?.data?.docs[widget.index]['stockTrn']}",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        "Item Name",
                        style: GoogleFonts.inter(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      "Rate",
                      style: GoogleFonts.inter(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Qty",
                      style: GoogleFonts.inter(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Total",
                      style: GoogleFonts.inter(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 1,
              width: double.maxFinite,
              color: Colors.white,
            ),
            Column(
              children: widget.items
                  .map((e) => ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text(
                                "${e['itemName']}",
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              "₹ ${e['itemrate']}",
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${e['itemQuantity']}",
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₹ ${e['itemrate'] * e['itemQuantity']}",
                              style: GoogleFonts.inder(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
            Container(
              width: double.maxFinite,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.white))),
              child: Text(
                "Total : ₹ ${widget.snapshot!.data!.docs[widget.index]['total']}",
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  color: cardColor, borderRadius: BorderRadius.circular(50)),
            )
          ],
        ),
      ),
    );
  }
}
