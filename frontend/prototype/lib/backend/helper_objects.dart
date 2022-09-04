import 'package:camera/camera.dart';

import 'data_base_functions.dart';

/// erzeugt ein Objekt das als Zwischenspeicher für die zukünftig zu speichernden Informationen
/// dient. Die Content Klasse beinhaltet außerdem Funktionen zum Arbeiten mit JSON-Dateien
/// TODO: singleton class? https://www.youtube.com/watch?v=noi6aYsP7Go
class Content {
  int id = 0;
  String projectName = "Default";
  String client = "Default";
  String date = "Default";
  String comment = "";
  Map<int, Wall> squareMeters = {};
  List<XFile?> pictures = [];
  String material = "Q2";
  int statusActive = 1;
  double aiValue = 41.0;

  /// übersetzt Objekt aus Json Format
  set fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectName = json['projectName'];
    client = json['client'];
    squareMeters = json['squareMeters'];
    material = json['material'];
    statusActive = json['statusActive'];
  }

  /// übersetzt Objekt in Json Format
  Map<String, dynamic> toJson() => {
        'id': id,
        'projectName': projectName,
        'client': client,
        'squareMeters': squareMeters,
        'material': material,
        'statusActive': statusActive
      };

  static Map<String, dynamic> contentToMap(Content content) {
    Map<String, dynamic> map = {
      'id': content.id,
      'projectName': content.projectName,
      'client': content.client,
      'date': content.date,
      'material': content.material,
      'aiValue': content.aiValue,
      'comment': content.comment
    };

    return map;
  }

/*
  static Future<List<XFile?>> getImagesOnly(int id) async {
    List<XFile?> listOfImages = [];
    await DataBase.getImages(id).then(
      (list) => {
        list.forEach((element) {
          listOfImages.add(XFile(element["image"].path));
        })
      },
    );
    return listOfImages;
  }
  */

  static Content mapToContent(Map<String, dynamic> map) {
    Content content = Content();
    content.id = map["id"];
    content.projectName = map["projectName"];
    content.client = map["client"];
    content.date = map["date"];
    content.pictures = [];
    content.material = map["material"];
    content.statusActive = map["statusActive"];
    content.comment = map["comment"];
    return content;
  }

  /// erzeugt ein leeres Porjekt, in welches später geladen JSON Daten eingesetzt werden können
  static Map<String, dynamic> emptyMap() {
    Map<String, dynamic> content = {
      'id': '',
      'projectName': "",
      'client': "",
      'squaremeters': [],
      'material': "",
      'statusActive': ""
    };

    return content;
  }
}

class User {
  late String firstName;
  late String lastName;
  late int customerId;
  late String address;

  static const Map<String, dynamic> emptyUser = {
    'firstName': "",
    'lastName': "",
    'customerId': 0,
    'address': ""
  };

  static Map<String, dynamic> userToMap(User user) {
    Map<String, dynamic> content = {
      'firstName': user.firstName,
      'lastName': user.lastName,
      'customerId': user.customerId,
      'address': user.address
    };

    return content;
  }

  static User mapToUser(Map map) {
    User user = User();

    user.firstName = map["firstName"];
    user.lastName = map['lastName'];
    user.customerId = map['customerId'];
    user.address = map['address'];

    return user;
  }
}

/// erzeugt eine MVP Wand, standardmäßig mit den Werten 0.0 * 0.0
class Wall {
  double width = 0.0;
  double height = 0.0;
}
