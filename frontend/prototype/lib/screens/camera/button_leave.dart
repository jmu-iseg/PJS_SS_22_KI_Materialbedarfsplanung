import 'package:flutter/material.dart';

import '../../styles/general.dart';

class ButtonLeave extends StatelessWidget {
  Function() leave;
  ButtonLeave({required this.leave});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
              border: Border.all(
                width: 2.0,
                color: GeneralStyle.getLightGray(),
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Icon(
            Icons.close,
            color: GeneralStyle.getLightGray(),
          ),
        ),
        onTap: () {
          leave();
        },
      ),
    );
  }
}
