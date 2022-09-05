import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';

import '../../styles/container.dart';
import '../backend/helper_objects.dart';

class ButtonsOrderBy extends StatefulWidget {
  final Function(List<Content>) orderChanged;
  String searchTerm;
  ButtonsOrderBy({required this.orderChanged, required this.searchTerm});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ButtonsOrderByState();
  }
}

class _ButtonsOrderByState extends State<ButtonsOrderBy> {
  int selectedIndex = 1000;

  currentOrderColor(int bottenrowPosition) {
    if (selectedIndex == bottenrowPosition) {
      return Color.fromARGB(255, 31, 8, 160);
    } else
      return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    Row buttonrow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text("Order by: "),
        ElevatedButton(
          child: Text("Client"),
          style: ElevatedButton.styleFrom(primary: currentOrderColor(0)),
          onPressed: () async {
            List<Content> newOrderList = await DataBase.getAllActiveProjects(
                widget.searchTerm, "client");
            widget.orderChanged(newOrderList);
            setState(() {
              selectedIndex = 0;
            });
          },
        ),
        ElevatedButton(
          child: Text("Name"),
          style: ElevatedButton.styleFrom(primary: currentOrderColor(1)),
          onPressed: () async {
            List<Content> newOrderList = await DataBase.getAllActiveProjects(
                widget.searchTerm, "projectName");
            widget.orderChanged(newOrderList);
            setState(() {
              selectedIndex = 1;
            });
          },
        ),
        ElevatedButton(
          child: Text("Datum"),
          style: ElevatedButton.styleFrom(primary: currentOrderColor(2)),
          onPressed: () async {
            List<Content> newOrderList =
                await DataBase.getAllActiveProjects(widget.searchTerm, "date");
            widget.orderChanged(newOrderList);
            setState(() {
              selectedIndex = 2;
            });
          },
        )
      ],
    );
    return buttonrow;
  }
}