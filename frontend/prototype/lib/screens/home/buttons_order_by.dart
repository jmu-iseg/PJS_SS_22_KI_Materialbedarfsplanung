import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/components/button_column_multiple_icons.dart';

import '../../../styles/container.dart';
import '../../backend/helper_objects.dart';

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
      return Color.fromARGB(255, 115, 115, 115);
    } else
      return Color.fromARGB(255, 196, 196, 196);
  }

  @override
  Widget build(BuildContext context) {
    Row buttonrow = Row(
      children: <Widget>[
        CustomButtonColumn(
          children: [
            Icon(
              Icons.person_pin_circle_outlined,
              color: currentOrderColor(0),
            ),
            Text(
              "Kunde",
              style: TextStyle(
                color: currentOrderColor(0),
              ),
            ),
          ],
          onPressed: () async {
            List<Content> newOrderList = await DataBase.getProjects(
              searchTerm: widget.searchTerm,
              orderByParamter: "client",
            );
            widget.orderChanged(newOrderList);
            setState(() {
              selectedIndex = 0;
            });
          },
        ),
        CustomButtonColumn(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: currentOrderColor(1),
            ),
            Text(
              "Ort",
              style: TextStyle(
                color: currentOrderColor(1),
              ),
            ),
          ],
          onPressed: () async {
            List<Content> newOrderList = await DataBase.getProjects(
              searchTerm: widget.searchTerm,
              orderByParamter: "city",
            );
            widget.orderChanged(newOrderList);
            setState(() {
              selectedIndex = 1;
            });
          },
        ),
        CustomButtonColumn(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              color: currentOrderColor(2),
            ),
            Text(
              "Datum",
              style: TextStyle(
                color: currentOrderColor(2),
              ),
            )
          ],
          onPressed: () async {
            List<Content> newOrderList = await DataBase.getProjects(
              searchTerm: widget.searchTerm,
              orderByParamter: "date",
            );
            widget.orderChanged(newOrderList);
            setState(() {
              selectedIndex = 2;
            });
          },
        ),
        CustomButtonColumn(
          children: [
            Icon(
              Icons.folder_open,
              color: currentOrderColor(3),
            ),
            Text(
              "Archiv",
              style: TextStyle(
                color: currentOrderColor(3),
              ),
            )
          ],
          onPressed: () async {
            List<Content> newOrderList = await DataBase.getProjects(
              searchTerm: widget.searchTerm,
              statusActive: 0,
            );
            widget.orderChanged(newOrderList);
            setState(() {
              selectedIndex = 3;
            });
          },
        ),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text("Sortieren nach"), buttonrow],
    );
  }
}