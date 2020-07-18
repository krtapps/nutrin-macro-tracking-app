import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateNewFoodPage extends StatefulWidget {
  @override
  _CreateNewFoodPageState createState() => _CreateNewFoodPageState();
}

class _CreateNewFoodPageState extends State<CreateNewFoodPage> {
  final _foodFormKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var carbsController = TextEditingController();
  var proteinController = TextEditingController();
  var fatController = TextEditingController();
  var servingSizeController = TextEditingController();
  var dropDownValue = "g";
  var dropDownValues = ["g", "cups", "mL"];

  @override
  void initState() {
    nameController.addListener(_printName);
    carbsController.addListener(_printCarbohydrates());
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    nameController.dispose();
    carbsController.dispose();
    proteinController.dispose();
    fatController.dispose();
    super.dispose();
  }

  _printName() {
    print(nameController.text);
  }

  _printCarbohydrates() {
    print(carbsController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Create New Food"),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.camera_alt),
            )
          ],
        ),
      ),
      body: Form(
        key: _foodFormKey,
        child: Container(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              macroFeild("Name", nameController, false),
              macroFeild("Carbohydrates (g)", carbsController, true),
              macroFeild("Protein (g)", proteinController, true),
              macroFeild("Fat (g)", fatController, true),
              servingSizeFeild(),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  if (_foodFormKey.currentState.validate()) {
                    print("YEs");
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget servingSizeFeild() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Serving Size",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 50,
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(),
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    validator: (value) =>
                        value.isEmpty ? 'Please enter a number' : null,
                    onChanged: (t) {
                      print(servingSizeController.text);
                    },
                    controller: servingSizeController,
                  ),
                ),
                DropdownButton(
                  underline: Container(
                    color: Theme.of(context).primaryColor,
                  ),
                  value: dropDownValue,
                  onChanged: (String unit) {
                    dropDownValue = unit;
                    print(dropDownValue);
                  },
                  items: dropDownValues
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget macroFeild(
      String macro, TextEditingController controller, bool numeric) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              macro,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              width: 100,
              child: TextFormField(
                keyboardType: numeric
                    ? TextInputType.numberWithOptions()
                    : TextInputType.text,
                validator: (value) =>
                    value.isEmpty ? 'Please enter a number' : null,
                onChanged: (t) {
                  print(controller.text);
                },
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
