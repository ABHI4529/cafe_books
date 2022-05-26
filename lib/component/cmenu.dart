import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';

class CMenu extends StatefulWidget {
  const CMenu({Key? key}) : super(key: key);

  @override
  State<CMenu> createState() => _CMenuState();
}

class _CMenuState extends State<CMenu> {
  @override
  Widget build(BuildContext context) {
    return FabCircularMenu(
      children: [
        TextButton(
          onPressed: (){},
          child: Text("Sale"),
        )
      ],
    );
  }
}
