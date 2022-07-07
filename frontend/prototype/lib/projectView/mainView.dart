import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prototype/localDrive/file_utils.dart';
import 'package:prototype/localDrive/content.dart';
import 'package:prototype/projectView/gallery.dart';
import 'package:prototype/projectView/projectGalerydemoVersion.dart';
import 'package:prototype/projectView/projectMap.dart';

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
/*
  Map<String, dynamic> getJsonValues() {
    FileUtils.getSpecificProject(id).then((loadedContent) {
      setState(() {
        content = loadedContent;
        ProjectView.src = loadedContent["id"].toString();
      });
    });
    return content;
  }
  */

  double getSquareMeter() {
    var squareMeters = widget.content["squareMeters"];
    double totalSquareMeters = 0.0;
    squareMeters.forEach((element) {
      double width = 0.0;
      double height = 0.0;
      try {
        width = element["width"];
        height = element["height"];
      } catch (e) {}
      double actualSquareMeters = width * height;
      totalSquareMeters = totalSquareMeters + actualSquareMeters;
    });
    return totalSquareMeters;
  }

  double getPrice() {
    String material = widget.content["material"];
    Map<String, double> valueInterpreter = {"Q2": 0.7, "Q3": 2, "Q4": 3.5};
    double totalPrice = 0.0;

    totalPrice = getSquareMeter() * valueInterpreter[material]!;

    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> content = widget.content;
    // getJsonValues();
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
        Text("Quadratmeter: " + getSquareMeter().toString()),
        Text("Preis: " + getPrice().toString()),
        Container(
          margin: const EdgeInsets.all(10.0),
          //    child: Text("Adresse: " + element + "straße"),
        ),
        Text("Fälligkeitsdatum: 15.05.2022"),
        Gallery(content["id"].toString()),
      ]),
    );
  }
}
