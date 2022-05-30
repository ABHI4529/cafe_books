import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../component/ctextfield.dart';
import '../../component/usnackbar.dart';
import 'addexpense.dart';

class EditExpense extends StatefulWidget {
  String expenseName;
  String expenseAmount;
  String expenseId;
  EditExpense(
      {Key? key,
      required this.expenseName,
      required this.expenseAmount,
      required this.expenseId})
      : super(key: key);

  @override
  State<EditExpense> createState() => _EditExpenseState();
}

final _expenseNameController = TextEditingController();
final _expenseAmoutController = TextEditingController();

class _EditExpenseState extends State<EditExpense> {
  Future addexpense() async {
    expenseCollectionRef.doc(widget.expenseId).set({
      "expName": _expenseNameController.text,
      "expAmount": _expenseAmoutController.text,
      "dateCreated": DateTime.now()
    });
  }

  @override
  void initState() {
    _expenseNameController.text = widget.expenseName;
    _expenseAmoutController.text = widget.expenseAmount;
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
          "Expense Creation",
          style: GoogleFonts.inter(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CTextField(
              controller: _expenseNameController,
              placeholder: "Expense Name",
            ),
            CTextField(
              textInputType: TextInputType.number,
              controller: _expenseAmoutController,
              placeholder: "Amount",
            ),
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: CupertinoButton(
                color: const Color(0xff1A659E),
                onPressed: () {
                  if (_expenseAmoutController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(USnackbar(
                      message: "Expense Name Required",
                      color: Colors.red.shade700,
                    ));
                  } else {
                    addexpense().then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(USnackbar(
                        message: "Expense Updated",
                        color: const Color(0xff1A659E),
                      ));
                      _expenseNameController.clear();
                      _expenseAmoutController.clear();
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
