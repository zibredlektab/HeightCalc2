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
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      title: nameWidget,
      subtitle: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        child: Row(
          children: [
            SizedBox(width: 5),
            Expanded(
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
            SizedBox(width: 5),
          ],
        ),
      ),
      trailing: trailingButton
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

  Widget configWidget(ComplexSupportConfiguration configuration) {
    TextEditingController minHeightController = TextEditingController();
    TextEditingController maxHeightController = TextEditingController();
    TextEditingController configNameController = TextEditingController();
    if (_editing) {
      minHeightController.text = "${configuration.minHeight}";
      maxHeightController.text = "${configuration.maxHeight}";
      if (configuration.name.isEmpty || configuration.name == "default") {
        configNameController.text = "Default";
      } else {
        configNameController.text = configuration.name;
      }
      return Row(
        children: [
          SizedBox(
            width: 200,
            height: 40,
            child: TextField(
              controller: configNameController,
            ),
          ),
          Text(": "),
          SizedBox(
            width: 75,
            height: 40,
            child: TextField(
              controller: minHeightController,
            ),
          ),
          Text(" -  "),
          SizedBox(
            width: 75,
            height: 40,
            child: TextField(
              controller: maxHeightController,
            ),
          ),
          Text(" inches"),
        ],
      );
    } else {
      if (configuration.name.isNotEmpty) {
        return Text('${configuration.name}: ${configuration.minHeight} - ${configuration.maxHeight} inches');
      } else {
        return Text('Default: ${configuration.minHeight} - ${configuration.maxHeight} inches');
      }
    }
  }

  Widget get trailingButton {
    if (_editing) {
      return IconButton(
        onPressed: _save,
        icon: Icon(Icons.check),
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

  void _save() {
    _provider.updateItem(_item, name: _nameEditingController.text);
    _toggleEdit();
  }

}