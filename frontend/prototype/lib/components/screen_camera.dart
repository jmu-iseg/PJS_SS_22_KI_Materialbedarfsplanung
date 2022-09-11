import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';
import 'package:flutter/services.dart';
import '../screens/create_new_project/_main_view.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final Function(List<CustomCameraImage>)? updateGallery;
  List<CustomCameraImage> originalGallery;
  CameraPage(
      {this.cameras,
      Key? key,
      this.updateGallery,
      this.originalGallery = const []})
      : super(key: key);
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  bool fotoFeedBack = false;
  XFile? pictureFile;
  List<XFile?> previewImages = [];
  List<CustomCameraImage> newImages = [];
  int id = 0;

  Widget preview() {
    Column column = Column(
      children: [],
    );

    if (previewImages.isNotEmpty) {
      for (var picture in previewImages) {
        column.children.add(Image.file(
          File(picture!.path),
          width: 50,
        ));
      }
    }
    return column;
  }

  @override
  void initState() {
    super.initState();
    if (widget.originalGallery.isNotEmpty) {
      id = widget.originalGallery.last.id + 1;
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    controller = CameraController(
      widget.cameras!.first,
      ResolutionPreset.medium,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

    for (var element in widget.originalGallery) {
      if (element.display) {
        previewImages.add(element.image);
      }
    }

    print(">>>>>>>>>>>>>>>>>>>>>>${widget.cameras}");
  }

  @override
  void dispose() {
    controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  /// TODO
  Widget addBlackBox() {
    return Container(
      width: 80,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(color: Color.fromARGB(69, 0, 0, 0)),
    );
  }

  Widget addCameraFeedback() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Color.fromARGB(137, 255, 255, 255),
      ),
    );
  }

  Widget getPhotoButton(Alignment alignment) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
      child: Align(
        alignment: alignment,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(17),
            primary: Colors.white,
          ),
          onPressed: () async {
            pictureFile = await controller.takePicture();
            previewImages.add(pictureFile!);

            newImages.add(
              CustomCameraImage(id: id, image: pictureFile!),
            );

            id += 1;
            setState(() {
              fotoFeedBack = true;
            });
            var bla = await Future.delayed(Duration(milliseconds: 30));
            setState(() {
              fotoFeedBack = false;
            });
          },
          child: const Icon(
            Icons.camera,
            color: Color.fromARGB(80, 0, 0, 0),
            size: 45,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Row(
      children: [
        Expanded(
          flex: 8,
          child: Center(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    child: CameraPreview(controller),
                  ),
                ),
                Align(
                  child: addBlackBox(),
                  alignment: Alignment.centerRight,
                ),
                Center(
                  child: Visibility(
                    visible: fotoFeedBack,
                    child: addCameraFeedback(),
                  ),
                ),
                getPhotoButton(Alignment.centerLeft),
                getPhotoButton(Alignment.centerRight),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        primary: Colors.red,
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();

                        widget.updateGallery!(newImages);
                      },
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        /*
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(25),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();

                widget.updateGallery!(newImages);
              },
              child: Icon(Icons.close),
            ),
          ),
        ),
        */
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: preview(),
          ),
        )
      ],
    );
  }
}
