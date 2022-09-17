import 'package:flutter/material.dart';
import 'package:prototype/components/input_field.dart';

class AddressInput extends StatefulWidget {
  Function(Adress) updateAddress;
  Adress adress;
  bool mandatory;
  Function(bool)? completeAdress;
  AddressInput(
      {required this.updateAddress,
      this.mandatory = false,
      this.completeAdress,
      this.adress =
          const Adress(street: "", houseNumber: "", zip: "", city: "")});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddressInputState();
  }
}

class AddressInputState extends State<AddressInput> {
  String street = "";
  String houseNumber = "";
  String city = "";
  String zip = "";
  static bool streetComplete = false;
  static bool houseNrComplete = false;
  static bool zipComplete = false;
  static bool cityComplete = false;
  static bool adressComplete =
      streetComplete && houseNrComplete && zipComplete && cityComplete;

  @override
  void initState() {
    super.initState();
    street = widget.adress.street;
    houseNumber = widget.adress.houseNumber;
    city = widget.adress.city;
    zip = widget.adress.zip;
  }

  checkAdressComplete() {
    if (adressComplete) {
      widget.completeAdress!(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 206, 206, 206))),
      child: Wrap(
        spacing: 20, // to apply margin in the main axis of the wrap
        runSpacing: 20, // to apply margin in the cross axis of the wrap
        children: <Widget>[
          Text("Adresse"),
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 7,
                child: InputField(
                  formComplete: (formCompleteController) {
                    streetComplete = formCompleteController;
                  },
                  disableMargin: true,
                  value: widget.adress.street,
                  mandatory: widget.mandatory,
                  saveTo: (value) {
                    street = value;
                    widget.updateAddress(Adress(
                        street: street,
                        houseNumber: houseNumber,
                        zip: zip,
                        city: city));
                  },
                  labelText: "Straße",
                ),
              ),
              Expanded(
                flex: 3,
                child: InputField(
                    formComplete: (formCompleteController) {
                      houseNrComplete = formCompleteController;
                    },
                    value: widget.adress.houseNumber,
                    mandatory: widget.mandatory,
                    disableMargin: true,
                    saveTo: (value) {
                      houseNumber = value;
                      widget.updateAddress(Adress(
                          street: street,
                          houseNumber: houseNumber,
                          zip: zip,
                          city: city));
                    },
                    labelText: "Nr."),
              ),
            ],
          ),
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: InputField(
                    formComplete: (formCompleteController) {
                      zipComplete = formCompleteController;
                    },
                    value: widget.adress.zip,
                    mandatory: widget.mandatory,
                    disableMargin: true,
                    saveTo: (value) {
                      zip = value;
                      widget.updateAddress(Adress(
                          street: street,
                          houseNumber: houseNumber,
                          zip: zip,
                          city: city));
                    },
                    labelText: "Postleitzahl"),
              ),
              Expanded(
                flex: 1,
                child: InputField(
                    formComplete: (formCompleteController) {
                      cityComplete = formCompleteController;
                    },
                    value: widget.adress.city,
                    mandatory: widget.mandatory,
                    disableMargin: true,
                    saveTo: (value) {
                      city = value;
                      widget.updateAddress(Adress(
                          street: street,
                          houseNumber: houseNumber,
                          zip: zip,
                          city: city));
                    },
                    labelText: "Stadt"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Adress {
  final String street;
  final String houseNumber;
  final String city;
  final String zip;
  const Adress(
      {required this.street,
      required this.houseNumber,
      required this.zip,
      required this.city});
}
