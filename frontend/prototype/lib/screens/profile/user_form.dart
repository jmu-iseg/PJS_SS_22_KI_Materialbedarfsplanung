import 'package:flutter/material.dart';
import 'package:prototype/backend/data_base_functions.dart';
import 'package:prototype/backend/helper_objects.dart';
import 'package:prototype/components/input_field.dart';
import 'package:prototype/components/input_field_address.dart';
import 'package:prototype/screens/load_project/button_send_mail.dart';
import 'package:prototype/styles/container.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/custom_container_border.dart';

class UserForm extends StatefulWidget {
  final Function(User user) updateValues;
  double aiValue;
  bool allValuesMandatory;
  User? editUser;
  UserForm({
    required this.updateValues,
    this.aiValue = 0.0,
    this.editUser,
    this.allValuesMandatory = false,
  });
  @override
  _UserFormState createState() {
    return _UserFormState();
  }
}

class _UserFormState extends State<UserForm> {
  User cache = User();
  static bool preNameComplete = false;
  static bool familyNameComplete = false;
  static bool addressComplete = false;
  static bool idComplete = false;

  static bool formComplete =
      (preNameComplete && familyNameComplete && addressComplete && idComplete);

  @override
  void initState() {
    // TODO: implement initState
    if (widget.editUser != null) {
      cache = widget.editUser!;
    }
    if (!widget.allValuesMandatory) {
      formComplete = true;
    }
  }

  Widget mailButtonIfComplete(bool status) {
    if (status) {
      return ButtonSendMail(widget.aiValue, cache);
    } else
      return Container();
  }

  String _idValue() {
    String idValue = "";
    if (cache.customerId == 0) {
      return idValue;
    } else {
      idValue = cache.customerId.toString();
    }

    return idValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputField(
          saveTo: (text) => {cache.firstName = text},
          labelText: "Vorname",
          icon: Icons.person,
          value: cache.firstName,
          formComplete: (formCompleteController) =>
              {preNameComplete = formCompleteController},
          mandatory: widget.allValuesMandatory,
        ),
        InputField(
          saveTo: (text) => {cache.lastName = text},
          labelText: "Nachname",
          icon: Icons.person_add,
          value: cache.lastName,
          formComplete: (formCompleteController) =>
              {familyNameComplete = formCompleteController},
          mandatory: widget.allValuesMandatory,
        ),
        InputField(
          saveTo: (text) => {cache.customerId = int.parse(text)},
          labelText: "Kundennummer",
          icon: Icons.numbers,
          inputType: TextInputType.number,
          formComplete: (formCompleteController) =>
              {idComplete = formCompleteController},
          value: _idValue(),
          mandatory: widget.allValuesMandatory,
        ),
        AddressInput(
          updateAddress: (address) {
            cache.street = address.street;
            cache.houseNumber = address.houseNumber;
            cache.zip = address.zip;
            cache.city = address.city;
          },
          adress: Adress(
            street: cache.street,
            houseNumber: cache.houseNumber,
            zip: cache.zip,
            city: cache.city,
          ),
          mandatory: widget.allValuesMandatory,
          completeAdress: (formCompleteController) =>
              {addressComplete = formCompleteController},
        ),
        ElevatedButton(
          onPressed: () async => {
            if (formComplete)
              {
                widget.updateValues(cache),
                if (widget.editUser == null)
                  {
                    await DataBase.createUserData(cache),
                  }
                else
                  {
                    await DataBase.updateUser(cache),
                  },
              }
          },
          child: Icon(Icons.save),
        ),
      ],
    );
  }
}
