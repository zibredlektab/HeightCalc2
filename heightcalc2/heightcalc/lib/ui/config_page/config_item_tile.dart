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
  bool _staticHeight = false;
  //late List<ComplexSupport> _list;

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
                          Switch(
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
                      SizedBox(
                        width: 75,
                        height: 48,
                        child: TextField(
                          controller: minHeightController,
                          decoration: minHeightDecoration,
                        ),
                      ),
                      if (configuration.adjustableHeight) ...[
                        Text(" -  "),
                        SizedBox(
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
            IconButton(onPressed: _deleteConfig, icon: Icon(Icons.delete_forever_outlined)),
          ],
        ),
      );
    } else {
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
            onPressed: _deleteItem,
            icon: Icon(Icons.delete_forever),
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

  void _deleteItem() {
    _provider.removeItem(_item);
  }

  void _save() {
    _provider.updateItem(_item, name: _nameEditingController.text);
    _toggleEdit();
  }

  void _deleteConfig() {

  }

}