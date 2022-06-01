import 'package:flutter/material.dart';

class DTextField extends StatefulWidget {
  Function? onSubmit;
  String value;
  DTextField({Key? key, required this.value, this.onSubmit}) : super(key: key);

  @override
  State<DTextField> createState() => _DTextFieldState();
}

class _DTextFieldState extends State<DTextField> {
  final controller = TextEditingController();
  @override
  void initState() {
    setState(() {
      controller.text = widget.value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
          border: UnderlineInputBorder(borderSide: BorderSide.none)),
      controller: controller,
      onSubmitted: (text) {
        setState(() {
          controller.text = text;
        });
      },
    );
  }
}
