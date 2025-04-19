import 'package:heightcalc/data_types/generic/complex_support.dart';
import 'package:heightcalc/data_types/generic/complex_support_configuration.dart';
import 'package:heightcalc/main.dart';
import 'package:flutter/services.dart';

class ConfigItemTile extends StatefulWidget {

  final ComplexSupport item;
  final HeightCalcAppState provider;

  const ConfigItemTile({
    required this.item,
    required this.provider,
    super.key});
  @override
  ConfigItemTileState createState() => ConfigItemTileState();
}

class ConfigItemTileState extends State<ConfigItemTile> {

  late bool _editing;
  late bool _newItem;
  late ComplexSupport _item;
  late HeightCalcAppState _provider = widget.provider;
  List<ConfigTextControllerManager> managers = [];
  late String errorText;

  TextEditingController _nameEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _provider = widget.provider;
    _item = ComplexSupport(type: widget.item.type, name: widget.item.name, configurations: List.empty());
    _item.configurations = List.from(widget.item.configurations); // make a local duplicate of the item in question
    for (var i = 0; i < _item.configurations.length; i++) {
      _item.configurations[i].id = widget.item.configurations[i].id; // gotta be sure
    }
    _editing = false;
    errorText = "";
  }
  

  @override
  Widget build(BuildContext context) {
    _item.name = widget.item.name;
    _newItem = widget.item.newItem;

    if (_newItem) {
      _editing = true;
    }

    managers = [];
    for (var i in _item.configurations) {
      managers.add(ConfigTextControllerManager(minHeightController: TextEditingController(), maxHeightController: TextEditingController(), configNameController: TextEditingController(), newConfig: i.newConfig));
    }

    return Consumer<HeightCalcAppState>(
      builder: (_, provider, _) {
        return Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  Expanded(
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        nameWidget,
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Configurations:", style: TextStyle(fontSize: 12),),
                                  if (_editing)
                                    IconButton(
                                      icon: Icon(Icons.add_circle_outline),
                                      onPressed: (){
                                        _addConfig();
                                      },
                                    ),
                                ],
                              ),
                              for (var j = 0; j < _item.configurations.length; j++) ...[
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: configWidget(configuration: _item.configurations[j], manager: managers[j]),
                                  )
                                ),
                              ],
                              Gap(0),
                            ],
                          ),
                        ),
                      ],
                    )
                  ),
                  trailingButton,
                ]
              ),
            ],
          ),
        );
      }
    );
  }

  Widget get nameWidget {
    if (_editing) {
      _nameEditingController.text = _item.name;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            height: 40,
            child: TextFormField(
              controller: _nameEditingController,
              decoration: InputDecoration(hintText: "Name"),
              autovalidateMode: AutovalidateMode.always,
              validator: (String? newName) {
                // TODO check if name is valid (unique)
                return null;
              },
              onChanged: (String? newName) {
                if (newName != null) {
                  _item.name = newName;
                } else {
                  _item.name = "";
                }
              },
            ),
          ),
          Gap(10),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_item.name),
          Gap(10),
        ],
      );
    }
  }

  var testSwitch = false;

  Widget configWidget({
    required ComplexSupportConfiguration configuration,
    required ConfigTextControllerManager manager}) {
    TextEditingController minHeightController = manager.minHeightController;
    TextEditingController maxHeightController = manager.maxHeightController;
    TextEditingController configNameController = manager.configNameController;

    InputDecoration genericHeightDecoration = InputDecoration(
      errorStyle: TextStyle(fontSize: 0),
    );

    InputDecoration minHeightDecoration = genericHeightDecoration.copyWith(
      label: Text("Min height"),
      hintText: "Min",
    );

    InputDecoration maxHeightDecoration = genericHeightDecoration.copyWith(
      label: Text("Max height"),
      hintText: "Min",
    );


    if (configuration.adjustableHeight) {
      minHeightDecoration = minHeightDecoration.copyWith(label: Text("Min Height"), hintText:"Min");
    } else {
      minHeightDecoration = minHeightDecoration.copyWith(label: Text("Height"), hintText:"Height");
    }

    if (errorText != "") {
      print("There are errors");
    }

    if (_editing) {
      minHeightController.text = "${configuration.minHeight}";
      maxHeightController.text = "${configuration.maxHeight}";
      if (configuration.name.isEmpty || configuration.name == "default") {
        configNameController.text = "Default";
      } else {
        configNameController.text = configuration.name;
      }

      
      return Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded( // Expanded makes sure full-width widgets still work down the tree
                  child: Column(
                    spacing: 5,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: TextFormField(
                          controller: configNameController,
                          decoration: InputDecoration(label: Text("Configuration Name"), hintText: "Name"),
                          validator: (String? text){
                            if (text != null && _item.isConfigNameUnique(name: text)) {
                              errorText = "";
                              return null;
                            } else {
                              errorText = "Config name \"$text\" is not unique.";
                              return "Config name \"$text\" is not unique.";
                            }
                          },
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: (String? newName) {
                            if (newName != null) {
                              configuration.name = newName;
                            }
                          },
                        ),
                      ),
                      Row(
                        spacing: 5,
                        children: [
                          Column(
                            children: [
                              Switch( // Static/adjustable switch
                                value: configuration.adjustableHeight,
                                onChanged: (bool value) {
                                  setState(() {
                                    if (value) {
                                      print("Configuration ${configuration.name} is now adjustable");
                                    } else {
                                      print("Configuration ${configuration.name} is no longer adjustable");
                                    }
                                    configuration.adjustableHeight = value;
                                    manager.maxHeightController.text = manager.minHeightController.text;
                                  });
                                },
                              ),
                              Text("Adjustable", style: TextStyle(fontSize: 10),),
                            ],
                          ),
                          Gap(10),
                          SizedBox( // Min height
                            width: 75,
                            height: 48,
                            child: TextFormField(
                              controller: minHeightController,
                              decoration: minHeightDecoration,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              autovalidateMode: AutovalidateMode.always,
                              validator: (String? text) {
                                int newMin = 0;
                                if (text != null) {
                                  try {
                                    newMin = int.parse(text);
                                  } catch (_) {
                                    errorText = "Invalid input";
                                    return 'Invalid input';
                                  }
                                  
                                  if (configuration.adjustableHeight && newMin > int.parse(manager.maxHeightController.text)) {
                                    errorText = "Max must be higher than min";
                                    return 'Min must be lower than Max';
                                  } else {
                                    errorText = "";
                                    return null;
                                  }
                                }

                                errorText = "";
                                return null;
                              },
                              onChanged: (String? newHeight) {
                                if (newHeight != null) {
                                  configuration.minHeight = int.parse(newHeight);
                                }
                              },
                            ),
                          ),
                          if (configuration.adjustableHeight) ...[
                            Text(" -  "),
                            SizedBox( // Max height
                              width: 75,
                              height: 48,
                              child: TextFormField(
                                controller: maxHeightController,
                                keyboardType: TextInputType.number,
                                decoration: maxHeightDecoration,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                autovalidateMode: AutovalidateMode.always,
                                validator: (String? text) {
                                  int newMax = 0;
                                  if (text != null) {
                                    try {
                                      newMax = int.parse(text);
                                    } catch (_) {
                                      errorText = "Invalid number entered";
                                      return 'Invalid input';
                                    }

                                    if (newMax < int.parse(manager.minHeightController.text)) {
                                      errorText = "Max must be higher than min";
                                      return 'Max must be lower than min';
                                    } else {
                                      errorText = "";
                                      return null;
                                    }
                                  }

                                  errorText = "";
                                  return null;
                                },
                                onChanged: (String? newHeight) {
                                  if (newHeight != null) {
                                    configuration.maxHeight = int.parse(newHeight);
                                  }
                                },
                              ),
                            ),
                          ],
                          Text(" inches"),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton( // Remove configuration
                  icon: Icon(Icons.delete_forever_outlined),
                  onPressed: () {
                    _askForDeletion(config: configuration);
                  },
                ),
              ],
            ),
          );
        }
      );
    } else { // Not editing view
      String heightLabel = "";
      if (configuration.name.isEmpty) {
        heightLabel = "Default";
      } else {
        heightLabel = configuration.name;
      }
      heightLabel += ": ${configuration.minHeight}";
      if (configuration.adjustableHeight) {
        heightLabel += " - ${configuration.maxHeight}";
      }
      heightLabel += " inches";

      return Text(heightLabel);

    }
  }

  Widget get trailingButton {
    // Buttons at the right-most edge of item tile
    if (_editing) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              _save(managers:managers);
            },
            icon: Icon(Icons.check),
          ),
          if (!_newItem) ...[
            IconButton(
              onPressed: _toggleEdit,
              icon: Icon(Icons.cancel),
            ),
          ],
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              _askForDeletion();
            },
          )
        ],
      );
    } else {
      return IconButton(
        onPressed: _toggleEdit,
        icon: Icon(Icons.edit),
      );
    }
  }


  void _toggleEdit() {
    setState(() {
      _editing = !_editing;
    });
  }

  void _askForDeletion({ComplexSupportConfiguration? config}) {
    if (config != null && _item.configurations.length == 1) {
      _warnDefaultConfig(config);
    } else {
      _confirmDeletion(config: config);
    }
  }

  void _save({required List<ConfigTextControllerManager> managers}) {
    if (errorText != "") {
      _showError(error: errorText);
      print("There are errors, not saving");
      return;
    }
    
    for (var i in _item.configurations) {
      if (!i.adjustableHeight) {
        i.maxHeight = i.minHeight;
      } else if (i.minHeight == i.maxHeight) {
        i.adjustableHeight = true;
      }
    }

    _provider.updateItem(widget.item, name: _item.name, configs: _item.configurations);
    _toggleEdit();
  }

  void _addConfig() {
    setState(() {
      _item.addConfig();
    });
  }

  Future<void> _confirmDeletion({ComplexSupportConfiguration? config}) async {
    String toDelete = "";
    
    if (config != null) {
      toDelete = "configuration \"${config.name}\" on item \"${_item.name}\"";
    } else {
      toDelete = "item \"${_item.name}\"";
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete $toDelete?'),
                Text('This action is permanent.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                if (config != null) {
                  setState(() {
                    _item.removeConfig(config);
                  });
                } else {
                  _provider.removeItem(_item);
                }
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> _showError ({required String error}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('There is an error in one of your configurations:'),
                Gap(5),
                Text(error),
                Gap(5),
                Text("Please fix this error before saving."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _warnDefaultConfig(ComplexSupportConfiguration config) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is the only configuration of item ${_item.name}.'),
                Text('There must be at least one configuration. Do you want to delete the item instead?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Delete Item'),
              onPressed: () {
                _editing = false;
                _provider.removeItem(_item);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ConfigTextControllerManager {
  TextEditingController minHeightController = TextEditingController();
  TextEditingController maxHeightController = TextEditingController();
  TextEditingController configNameController = TextEditingController();
  bool newConfig = false;


  ConfigTextControllerManager({
    required this.minHeightController,
    required this.maxHeightController,
    required this.configNameController,
    required this.newConfig
    });
}