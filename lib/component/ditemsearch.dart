import 'package:cafe_books/screens/expense/addexpense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class DSerchField extends StatefulWidget {
  String value;
  DSerchField({Key? key, required this.value}) : super(key: key);

  @override
  State<DSerchField> createState() => _DSerchFieldState();
}

class _DSerchFieldState extends State<DSerchField> {
  final searchItemController = TextEditingController();
  @override
  void initState() {
    setState(() {
      searchItemController.text = widget.value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: expenseCollectionRef.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SearchField(
            searchInputDecoration: const InputDecoration(
                border: UnderlineInputBorder(borderSide: BorderSide.none)),
            controller: searchItemController,
            itemHeight: 30,
            onSuggestionTap: (suggestion) {},
            suggestions: snapshot.data!.docs
                .map((e) => SearchFieldListItem("${e['expName']}",
                    item: "${e['expAmount']}"))
                .toList(),
          );
        });
  }
}
