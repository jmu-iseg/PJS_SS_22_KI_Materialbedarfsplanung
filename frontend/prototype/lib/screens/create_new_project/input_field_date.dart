import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';

import '../../styles/container.dart';

class InputDate extends StatefulWidget {
  @override
  _InpuDateState createState() {
    // TODO: implement createState
    return _InpuDateState();
  }
}

class _InpuDateState extends State<InputDate> {
  TextEditingController dateinput = TextEditingController();
  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ContainerStyles.getMargin(),
      child: TextField(
        controller: dateinput,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1950),
              //DateTime.now() - not to allow to choose before today.
              lastDate: DateTime(2100));

          if (pickedDate != null) {
            String formattedDate = DateFormat('dd.MM.yyyy').format(pickedDate);

            setState(() {
              dateinput.text =
                  formattedDate; //set output date to TextField value.
              NewProject.cash.date = formattedDate;
            });
          }
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Datum",
        ),
      ),
    );
  }
}