import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:searchfield/searchfield.dart';

import 'overlays/unitoverlay.dart';

class DSearchField extends StatefulWidget {
  String label;
  List list;
  TextEditingController? controller;
  DSearchField(
      {Key? key, required this.label, required this.list, this.controller})
      : super(key: key);

  @override
  State<DSearchField> createState() => _DSearchFieldState();
}

class _DSearchFieldState extends State<DSearchField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: SearchField(
          controller: widget.controller,
          itemHeight: 40,
          onSuggestionTap: (suggestion) {},
          searchInputDecoration: InputDecoration(
              hintText: widget.label,
              hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
              constraints: BoxConstraints.loose(Size(double.maxFinite, 40)),
              contentPadding: const EdgeInsets.only(left: 10),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide:
                      BorderSide(color: Colors.grey.shade300, width: 1.8)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide:
                      BorderSide(color: Colors.grey.shade300, width: 1.8)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide:
                      BorderSide(color: Colors.grey.shade300, width: 1.8))),
          suggestions: widget.list.map((e) => SearchFieldListItem(e)).toList(),
        ));
  }
}
