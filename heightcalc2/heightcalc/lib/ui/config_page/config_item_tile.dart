import 'package:heightcalc/data_types/generic/complex_support.dart';
import 'package:heightcalc/data_types/generic/complex_support_configuration.dart';
import 'package:heightcalc/main.dart';

class ConfigItemTile extends StatefulWidget {

  final ComplexSupport item; 
  final HeightCalcAppState provider;

  const ConfigItemTile({required this.item, required this.provider, super.key});
  @override
  ConfigItemTileState createState() => ConfigItemTileState();
}

class ConfigItemTileState extends State<ConfigItemTile> {

  bool _editing = false;
  late ComplexSupport _item;
  late HeightCalcAppState _provider = widget.provider;

  TextEditingController _nameEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _provider = widget.provider;
    //_list = widget.list;
    _editing = false;
  }

  @override
  Widget build(BuildContext context) {

    _item = widget.item;
    print("Item name is ${_item.name}");

    print("rebuilding config tile for ${_item.name}");

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
                              Text("Configurations:", style: TextStyle(fontSize: 12),),
                              for (var j in _item.configurations) ...[
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: configWidget(j)
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
            child: TextField(
              controller: _nameEditingController,
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

  Widget configWidget(ComplexSupportConfiguration configuration) {
    TextEditingController minHeightController = TextEditingController();
    TextEditingController maxHeightController = TextEditingController();
    TextEditingController configNameController = TextEditingController();

    InputDecoration minHeightDecoration = InputDecoration(label: Text("Min height"), hintText: "Min");

    if (configuration.adjustableHeight) {
      minHeightDecoration = minHeightDecoration.copyWith(label: Text("Min Height"), hintText:"Min");
    } else {
      minHeightDecoration = minHeightDecoration.copyWith(label: Text("Height"), hintText:"Height");
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
                        child: TextField(
                          controller: configNameController,
                          decoration: InputDecoration(label: Text("Configuration Name"), hintText: "Name"),
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
                                    configuration.adjustableHeight = value;
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
                            child: TextField(
                              controller: minHeightController,
                              decoration: minHeightDecoration,
                            ),
                          ),
                          if (configuration.adjustableHeight) ...[
                            Text(" -  "),
                            SizedBox( // Max height
                              width: 75,
                              height: 48,
                              child: TextField(
                                controller: maxHeightController,
                                decoration: InputDecoration(label: Text("Max height"), hintText: "Max"),
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
      if (configuration.minHeight != configuration.maxHeight) {
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
            onPressed: _save,
            icon: Icon(Icons.check),
          ),
          IconButton(
            onPressed: _toggleEdit,
            icon: Icon(Icons.cancel),
          ),
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

  void _save() {
    _provider.updateItem(_item, name: _nameEditingController.text);
    _toggleEdit();
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
                  _provider.removeConfig(item: _item, config: config);
                } else {
                  _provider.removeItem(_item);
                }
                _toggleEdit();
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


  Future<void> _warnDefaultConfig(ComplexSupportConfiguration config) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
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