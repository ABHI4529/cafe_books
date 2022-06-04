import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CTextField<T> extends StatefulWidget {
  String? placeholder;
  TextInputType? textInputType;
  FocusNode? focus;
  TextEditingController? controller;
  Widget? widgetPrefix;
  int? maxline;
  Widget? prefix;
  ValueChanged<String>? onTextChanged;
  final Function(String)? onSubmit;
  CTextField(
      {Key? key,
      this.maxline,
      this.focus,
      this.prefix,
      this.placeholder,
      this.onTextChanged,
      this.controller,
      this.onSubmit,
      this.textInputType,
      this.widgetPrefix})
      : super(key: key);

  @override
  State<CTextField> createState() => _CTextFieldState();
}

class _CTextFieldState extends State<CTextField> {
  Color labelColor = Colors.grey.shade300;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Focus(
        onFocusChange: (focus) {
          if (focus) {
            setState(() {
              labelColor = Colors.indigo.shade600;
            });
          } else {
            setState(() {
              labelColor = Colors.grey.shade300;
            });
          }
        },
        child: TextFormField(
          onChanged: widget.onTextChanged,
          focusNode: widget.focus,
          keyboardType: widget.textInputType,
          controller: widget.controller,
          onFieldSubmitted: widget.onSubmit,
          decoration: InputDecoration(
              suffixIcon: widget.widgetPrefix,
              prefixIcon: widget.prefix,
              labelText: widget.placeholder,
              labelStyle: GoogleFonts.inter(color: labelColor),
              constraints:
                  BoxConstraints.loose(const Size(double.maxFinite, 40)),
              contentPadding: const EdgeInsets.only(left: 10),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide:
                      BorderSide(color: Colors.indigo.shade700, width: 1.8)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide:
                      BorderSide(color: Colors.grey.shade300, width: 1.8)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide:
                      BorderSide(color: Colors.grey.shade300, width: 1.8))),
        ),
      ),
    );
  }
}
