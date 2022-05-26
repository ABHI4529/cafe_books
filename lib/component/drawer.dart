import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CDrawer extends StatefulWidget {
  const CDrawer({Key? key}) : super(key: key);

  @override
  State<CDrawer> createState() => _CDrawerState();
}

class _CDrawerState extends State<CDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.blue.shade700
            ),
            padding: const EdgeInsets.only(left: 20, right: 25, bottom: 25, top: 35),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Container(
                    margin: const EdgeInsets.only(right: 3),
                    child: Icon(FontAwesomeIcons.store),
                  )
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Abhinav Gadekar",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17
                        ),
                      ),
                      Text(
                        "abhinavgadekar4529@gmail.com",
                        style: GoogleFonts.inter(
                            color: Colors.white,
                          fontSize: 10
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "User Settings  ",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 12
                                ),
                            ),
                            const Icon(
                                FontAwesomeIcons.chevronDown,
                                size: 13,
                                color: Colors.white,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ),
          TextButton(
            onPressed: (){},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: const Icon(
                        FontAwesomeIcons.cartShopping,
                        color: Colors.grey,
                        size: 20,
                    )
                ),
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Text(
                        "Items",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                    )
                )
              ],
            ),
          ),
          TextButton(
            onPressed: (){},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: const Icon(
                      FontAwesomeIcons.house,
                      color: Colors.grey,
                      size: 20,
                    )
                ),
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Text(
                      "Home",
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    )
                )
              ],
            ),
          ),
          TextButton(
            onPressed: (){},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: const Icon(
                      FontAwesomeIcons.chartSimple,
                      color: Colors.grey,
                      size: 20,
                    )
                ),
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Text(
                      "Reports",
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    )
                )
              ],
            ),
          ),
          TextButton(
            onPressed: (){},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: const Icon(
                      FontAwesomeIcons.fileContract,
                      color: Colors.grey,
                      size: 20,
                    )
                ),
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Text(
                      "Sales",
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    )
                )
              ],
            ),
          ),
          TextButton(
            onPressed: (){},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: const Icon(
                      FontAwesomeIcons.wallet,
                      color: Colors.grey,
                      size: 20,
                    )
                ),
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Text(
                      "Expenses",
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    )
                )
              ],
            ),
          ),
          TextButton(
            onPressed: (){},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: const Icon(
                      FontAwesomeIcons.peopleGroup,
                      color: Colors.grey,
                      size: 20,
                    )
                ),
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Text(
                      "Customers",
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    )
                )
              ],
            ),
          ),
          TextButton(
            onPressed: (){},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: const Icon(
                      FontAwesomeIcons.kitchenSet,
                      color: Colors.grey,
                      size: 20,
                    )
                ),
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Text(
                      "Kitchen",
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
