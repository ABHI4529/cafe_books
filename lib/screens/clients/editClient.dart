import 'package:cafe_books/component/ctextfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../component/usnackbar.dart';
import 'addclient.dart';

class EditClient extends StatefulWidget {
  String clientName;
  String clientContact;
  String clientBalance;
  String clientId;
  EditClient(
      {Key? key,
      required this.clientId,
      required this.clientContact,
      required this.clientBalance,
      required this.clientName})
      : super(key: key);

  @override
  State<EditClient> createState() => _EditClientState();
}

final _clientNameController = TextEditingController();
final _clientContactController = TextEditingController();
final _clientBalanceController = TextEditingController();

class _EditClientState extends State<EditClient> {
  Future addclient() async {
    clientCollectionRef.doc(widget.clientId).set({
      "clientName": _clientNameController.text,
      "clientContact": _clientContactController.text,
      "clientBalance": _clientBalanceController.text,
      "dateCreated": DateTime.now()
    });
  }

  @override
  void initState() {
    _clientNameController.text = widget.clientName;
    _clientContactController.text = widget.clientContact;
    _clientBalanceController.text = widget.clientBalance;
    super.initState();
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
          "Client Alteration",
          style: GoogleFonts.inter(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CTextField(
              controller: _clientNameController,
              placeholder: "Customer Name",
            ),
            CTextField(
              controller: _clientContactController,
              placeholder: "Contact Number",
              textInputType: TextInputType.number,
            ),
            CTextField(
              controller: _clientBalanceController,
              placeholder: "Op. Bal",
              textInputType: TextInputType.number,
            ),
            Container(
              margin: const EdgeInsets.only(top: 100),
              child: CupertinoButton(
                color: const Color(0xff1A659E),
                onPressed: () {
                  if (_clientBalanceController.text.isEmpty) {
                    setState(() {
                      _clientBalanceController.text = "0";
                    });
                  }
                  if (_clientNameController.text.isEmpty ||
                      _clientContactController.text.characters.length > 10 ||
                      _clientContactController.text.characters.length < 10) {
                    ScaffoldMessenger.of(context).showSnackBar(USnackbar(
                      message: "Contact Number Or Name Is Incorrect",
                      color: Colors.red.shade600,
                    ));
                  } else {
                    addclient().then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(USnackbar(
                        message: "Client Added Successfully",
                        color: const Color(0xff1A659E),
                      ));
                      _clientNameController.clear();
                      _clientContactController.clear();
                      _clientBalanceController.clear();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  }
                },
                child: Text(
                  "Update",
                  style: GoogleFonts.inter(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
