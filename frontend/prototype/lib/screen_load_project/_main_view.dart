import 'dart:io';

import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/gallery.dart';
import 'package:prototype/screen_load_project/projectMap.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter/cupertino.dart';

import '../backend/ai.dart';
import '../components/gallery2.dart';

class ProjectView extends StatefulWidget {
  Map<String, dynamic> content;
  ProjectView(this.content);
  static String src = "";
  @override
  _ProjectViewState createState() {
    return _ProjectViewState();
  }
}

class _ProjectViewState extends State<ProjectView> {
  double totalSquareMeters = 0.0;
  double totalPrice = 0.0;
  var images = [];
  String outcome = "konnte nicht ermittelt werden";
  File pickedImage = File("");
  bool imagesLoaded = false;

  @override
  initState() {
    super.initState();
    totalSquareMeters = getSquareMeter();
    images = loadImages();
    //  outcome = AI.applyModelOnImage().toString();
  }

  loadImages() {
    var images = [];
    DataBase.getImages(widget.content["id"].toString()).then((imagelist) => {
          imagelist.forEach((element) {
            setState(() {
              images.add(element);
              imagesLoaded = true;
            });
          })
        });

    return images;
  }

  /// für MVP mit Wandeingabe
  double getSquareMeter() {
    DataBase.getWalls(widget.content["id"]).then((walls) {
      walls.forEach((element) async {
        double width = 0.0;
        double height = 0.0;
        try {
          width = element["width"];
          height = element["height"];
        } catch (e) {}
        double actualSquareMeters = width * height;
        setState(() {
          totalSquareMeters = totalSquareMeters + actualSquareMeters;
        });
      });
    });

    return totalSquareMeters;
  }

  /// für MVP mit Wandeingabe
  double getPrice() {
    String material = widget.content["material"];
    Map<String, double> valueInterpreter = {"Q2": 0.7, "Q3": 2, "Q4": 3.5};
    setState(() {
      totalPrice = totalSquareMeters * valueInterpreter[material]!;
    });

    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    // applyModelOnImage();
    Map<String, dynamic> content = widget.content;

    totalPrice = getPrice();
    // getJsonValues(); find the method in helper class
    return Scaffold(
      appBar: AppBar(
        title: Text(
          content["projectName"],
        ),
      ),
      body: Column(children: [
        // test to check if Project view is able to load data, which had been entered before
        Center(child: ProjectMap()),
        Text("Auftraggeber: " + content["client"]),
        Text("Quadratmeter: " + totalSquareMeters.toString()),
        Text("Preis: " + totalPrice.toString()),
        Text("KI-Ergebnis: " + outcome),
        Container(
          margin: const EdgeInsets.all(10.0),
          //    child: Text("Adresse: " + element + "straße"),
        ),
        Text("Fälligkeitsdatum: 15.05.2022"),
        Gallery2(images),
      ]),
    );
  }
}