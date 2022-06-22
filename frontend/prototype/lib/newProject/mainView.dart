import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prototype/localDrive/file_utils.dart';

import '../localDrive/content.dart';
import '../projectView/mainView.dart';
import 'input_field.dart';
import 'newAddress.dart';
import 'newPhotoButton.dart';

class NewProject extends StatefulWidget {
  String title = "Neues Projekt";
  // instanzieeren eines Contentobjekts, in dem sämtliche EIngabeinformationen zwischengespeichert werden
  static var cash = Content();
  @override
  State<StatefulWidget> createState() {
    return _NewProjectState();
  }
}

class _NewProjectState extends State<NewProject> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

/*
  Widget preview() {
    Row row = Row(
      children: [],
    );

    if (NewProject.cash.pictures.isNotEmpty) {
      for (var picture in NewProject.cash.pictures) {
        print(picture.toString() +
            "--------------------------------------------------------------");
        row.children.add(Image.file(
          File(picture!.path),
          width: 50,
        ));
      }
    }
    return row;
  }
  */

  goToProjectView() async {
    FileUtils.createId().then((id) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProjectView(id)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Neues Projekt"),
          primary: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Column(
              children: <Widget>[
                InputField(InputType.projectName),
                InputField(InputType.client),
                //  NewAddress(),
                AddPhotoButton(),
                //    preview(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      FileUtils.addToJsonFile(NewProject.cash);
                      FileUtils.saveImages(NewProject.cash.pictures);
                      //   goToProjectView();
                    },
                    child: const Text('Projekt speichern und berechnen'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
