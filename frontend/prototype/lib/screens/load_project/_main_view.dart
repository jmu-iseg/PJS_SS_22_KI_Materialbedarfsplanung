import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/button_multiple_icons.dart';
import 'package:prototype/components/custom_container_white.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';
import 'package:prototype/screens/load_project/editor.dart';
import 'package:prototype/components/gallery.dart';
import 'package:prototype/components/navBar.dart';
import 'package:prototype/screens/load_project/projectMap.dart';
import 'package:prototype/screens/load_project/webshop_api.dart';
import 'package:camera/camera.dart';
import 'package:prototype/styles/container.dart';
import '../../components/screen_camera.dart';
import '../../backend/value_calculator.dart';
import 'package:prototype/backend/data_base_functions.dart';

class ProjectView extends StatefulWidget {
  Content content;
  ProjectView(this.content);
  static bool askAgain = true;

  @override
  _ProjectViewState createState() {
    return _ProjectViewState();
  }
}

class _ProjectViewState extends State<ProjectView> {
  Map<String, dynamic> calculatedOutcome = {};
  bool editorVisablity = false;
  Content content = Content();
  List<XFile?> galleryPictures = [];
  List<XFile?> addedPictures = [];
  bool safeNewPicturesButton = false;
  bool imagesSaved = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOutcome();
    content = widget.content;
    galleryPictures = content.pictures;
  }

  Future<void> _showMyDialog() async {
    if (ProjectView.askAgain) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Kamera eisntellen'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Bitte Kamera quer halten'),
                  Text('Kameraeinstellung auf 4:3'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Approve'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    ProjectView.askAgain = false;
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }

  getOutcome() {
    ValueCalculator.getOutcomeObject(widget.content).then((value) => {
          setState(() {
            calculatedOutcome = value;
          })
        });
  }

  successMessage() async {
    imagesSaved = await DataBase.saveImages(addedPictures, content.id);
  }

  bool changeBool(bool input) {
    if (input == false) {
      return true;
    } else {
      return false;
    }
  }

  Icon getIcon() {
    if (editorVisablity) {
      return Icon(Icons.close);
    } else
      return Icon(Icons.edit);
  }

  @override
  Widget build(BuildContext context) {
    // getJsonValues();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          content.projectName,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          //      Center(child: ProjectMap()),
          CustomContainerWhite(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: !editorVisablity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Auftraggeber: " + content.client),
                      Text("Datum: " + content.date),
                      Text("Kommentar: " + content.comment)
                    ],
                  ),
                ),
                ElevatedButton(
                  child: getIcon(),
                  onPressed: () {
                    setState(() {
                      editorVisablity = changeBool(editorVisablity);
                    });
                  },
                ),
                Visibility(
                  visible: editorVisablity,
                  child: EditorWidget(
                    input: content,
                    route: ((data) {
                      setState(() {
                        content = data;
                        editorVisablity = false;
                      });
                    }),
                  ),
                ),
              ],
            ),
          ),
          // test to check if Project view is able to load data, which had been entered before
          CustomContainerWhite(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("KI-Ergebnis: " +
                    calculatedOutcome["aiOutcome"].toString()),
                Text("KI-Preis: " +
                    calculatedOutcome["totalAiPrice"].toString()),
              ],
            ),
          ),
          /*
            Text("Quadratmeter: " +
                    calculatedOutcome["totalSquareMeters"].toString()),
           Text("Preis: " + calculatedOutcome["totalPrice"].toString()),
*/
          Container(
            margin: const EdgeInsets.all(10.0),
            //    child: Text("Adresse: " + element + "straße"),
          ),
          Gallery(pictures: galleryPictures),

          CustomButton(
            children: const [
              Icon(
                Icons.add,
                color: Colors.white,
              ),
              Icon(
                Icons.image,
                color: Colors.white,
              ),
            ],
            onPressed: () async {
              await availableCameras().then((value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CameraPage(
                              cameras: value,
                              originalGallery: galleryPictures,
                              updateGallery: (images) {
                                setState(() {
                                  galleryPictures.addAll(images);
                                  addedPictures.addAll(images);
                                  safeNewPicturesButton = true;
                                });
                              },
                            )),
                  ));
            },
          ),
          CustomButton(
            children: const [
              Icon(
                Icons.add,
                color: Colors.white,
              ),
              Icon(
                Icons.image,
                color: Colors.white,
              ),
              Text(
                "Imagepicker",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
            onPressed: () async {
              final ImagePicker _picker = ImagePicker();
              var dialog = await _showMyDialog();
              // Pick an image

              final XFile? image = await _picker.pickImage(
                  source: ImageSource.camera, maxWidth: 400, maxHeight: 300);
              if (image != null) {
                setState(
                  () {
                    addedPictures.add(image);
                    galleryPictures.add(image);
                    safeNewPicturesButton = true;
                  },
                );
              }
            },
          ),
          Visibility(
            visible: safeNewPicturesButton,
            child: CustomButton(
              children: const [
                Icon(
                  Icons.image,
                  color: Colors.white,
                ),
                Icon(
                  Icons.save,
                  color: Colors.white,
                ),
              ],
              onPressed: () {
                setState(() {
                  safeNewPicturesButton = false;
                  successMessage();
                  imagesSaved = true;
                  addedPictures = [];
                });
              },
            ),
          ),
          Visibility(
            visible: imagesSaved,
            child: Text("Speichern erfolgreich"),
          ),

          Webshop(
            aiValue: calculatedOutcome["aiOutcome"],
          )
        ]),
      ),
      bottomNavigationBar: NavBar(4),
    );
  }
}
