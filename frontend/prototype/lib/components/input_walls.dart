import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/custom_container_border.dart';
import 'package:prototype/components/input_field.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';
import 'package:prototype/styles/general.dart';

import 'button_row_multiple_icons.dart';
import '../styles/container.dart';

class InputWalls extends StatefulWidget {
  Function(List<Wall>) updateValues;
  List<Wall> input;
  InputWalls({
    required this.updateValues,
    this.input = const [],
  });

  @override
  _InputWalls createState() {
    return _InputWalls();
  }
}

class _InputWalls extends State<InputWalls> {
  final TextEditingController nameController = TextEditingController();
  bool addVisabilty = false;

  /// Widgetliste sorgt dafür dass die Eingabefelder für neue Wände angezeigt werden
  Map<int, Widget> wallWidgets = {};

  /// hier werden sämtliche Daten zwischengespeichert, die der Nutzer beim Erstellungsprozess
  /// produziert
  Map<int, Wall> walls = {};

  /// Übergabeliste, enthält die Daten die später gespeichert werden sollen
  Map<int, Wall> safeList = {};
  int startId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.input.isNotEmpty) {
      startId = widget.input.last.id;

      initialSetUpWidgetMap();
    }

    getWallsVisability();
  }

  initialSetUpWidgetMap() {
    for (Wall element in widget.input) {
      setState(() {
        safeList[element.id] = element;
        walls[element.id] = element;
        wallWidgets[element.id] = newWall(widgetId: element.id, wall: element);
      });
    }
  }

  updateWidgetMap() {
    for (Wall element in walls.values) {
      setState(() {
        walls[element.id] = element;
        wallWidgets[element.id] = newWall(widgetId: element.id, wall: element);
      });
    }
  }

  /// sorgt dafür, dass wenn alle Wände aus der Liste gelöscht werden, stattdessen wieder der
  /// "Wand hinzufügen"-Button erscheint
  getWallsVisability() {
    int invisibleWalls = 0;
    walls.forEach((key, value) {
      if (value.display == false) {
        invisibleWalls += 1;
      }
    });
    if (walls.length == invisibleWalls) {
      setState(() {
        addVisabilty = false;
      });
    } else {
      setState(() {
        addVisabilty = true;
      });
    }
  }

  bool switchVisablity() {
    if (addVisabilty) {
      return false;
    } else {
      return true;
    }
  }

  /// wird jedesmal aufgerufen, wenn ein Wert eingegeben wird. Ist eine Wand vollständig (enthält beide Werte)
  /// wird sie der Liste der zu speichernden Wände beigefügt
  safeWall(Wall wall) {
    safeList[wall.id] = wall;

    safeList.removeWhere((key, element) => (element.width == 0.0 ||
        element.height == 0.0 ||
        element.display == false));

    widget.updateValues(safeList.values.toList());
  }

  /// sorgt dafür, dass das Feld, anstatt mit "0.0" vorausgefüllt zu werden, einfach keinen Wert einthält
  /// die 0.0 entsteht dadurch, dass 0.0 das Defaultmaß einer neuen Wand ist
  String setUpValue(double value) {
    if (value == 0.0) {
      return "";
    } else {
      return value.toString();
    }
  }

  /// erzeugt eine Zeile aus Textfeldern, mit denen eine neue Wand erstellt werden kann
  Widget newWall({
    required int widgetId,
    required Wall wall,
  }) {
    wall.id = widgetId;

    Container container = Container();

    if (wall.display) {
      container = Container(
        margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            // Feld "Typ"
            Expanded(
              flex: 3,
              child: InputField(
                  value: wall.name,
                  disableMargin: true,
                  saveTo: (text) {
                    wall.name = text;
                    safeWall(wall);
                  },
                  labelText: ""),
            ),
            // Feld "Breite"
            Expanded(
              flex: 3,
              child: InputField(
                  mandatory: true,
                  formComplete: (bool) {},
                  value: setUpValue(wall.width),
                  inputType: TextInputType.number,
                  disableMargin: true,
                  saveTo: (text) {
                    if (text == "") {
                      wall.width = 0.0;
                    } else {
                      wall.width = double.parse(text.replaceAll(',', '.'));
                    }
                    safeWall(wall);
                  },
                  labelText: ""),
            ),
            // Feld "Höhe"
            Expanded(
              flex: 3,
              child: InputField(
                  mandatory: true,
                  formComplete: (bool) {},
                  value: setUpValue(wall.height),
                  inputType: TextInputType.number,
                  disableMargin: true,
                  saveTo: (text) {
                    if (text == "") {
                      wall.height = 0.0;
                    } else {
                      wall.height = double.parse(text.replaceAll(',', '.'));
                    }
                    safeWall(wall);
                  },
                  labelText: ""),
            ),
            // Feld Delete-Button
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(
                    () {
                      wall.display = false;
                      getWallsVisability();
                    },
                  );
                  safeWall(wall);
                  updateWidgetMap();
                },
                child: Center(
                  child: Icon(
                    Icons.delete,
                    color: GeneralStyle.getDarkGray(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Visibility(
      child: container,
      visible: wall.display,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Visibility(
            visible: addVisabilty,
            child: Column(
              children: [
                // zeigt die Überschriften zu den drei Textboxen, das letzte Element ist ein leerer
                // Container, unter ihm werden die Lösch-Symbole aufgereiht
                Flex(direction: Axis.horizontal, children: [
                  Expanded(child: Text("Typ"), flex: 3),
                  Expanded(
                      child: Wrap(
                        children: [
                          Icon(Icons.sync_alt_outlined),
                          Text(" Breite (m)"),
                        ],
                      ),
                      flex: 3),
                  Expanded(
                      child: Wrap(
                        children: [
                          Icon(Icons.swap_vert_outlined),
                          Text(" Höhe (m)"),
                        ],
                      ),
                      flex: 3),
                  Expanded(child: Container(), flex: 1),
                ]),
                Column(
                  children: wallWidgets.values.toList(),
                ),
                // Hinzufügen-Button, erzeugt ein neues Wand-Element
                CustomButtonRow(
                    children: [Icon(Icons.add)],
                    onPressed: () {
                      Wall newWall = Wall();
                      newWall.id = startId;
                      setState(() {
                        walls[startId] = newWall;

                        startId += 1;
                      });
                      updateWidgetMap();
                    }),
              ],
            ),
          ),
          // By Default wird dieser Button angezeigt, geniert die este Wand, wird er betätigt
          Visibility(
            visible: switchVisablity(),
            child: ElevatedButton(
              child: const Text("Fläche manuell eingeben"),
              onPressed: () {
                Wall newWall = Wall();
                newWall.id = startId;

                setState(
                  () {
                    walls[startId] = newWall;
                    startId += 1;
                    getWallsVisability();
                  },
                );

                updateWidgetMap();
              },
            ),
          ),
        ],
      ),
      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
    );
  }
}
