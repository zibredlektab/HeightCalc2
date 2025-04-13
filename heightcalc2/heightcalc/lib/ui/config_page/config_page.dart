import 'package:heightcalc/data_types/data_types.dart';
import 'package:heightcalc/data_types/generic/complex_support_configuration.dart';
import 'package:heightcalc/inventory.dart';
import 'package:heightcalc/main.dart';
import 'config_item_tile.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});
  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {

  @override
  Widget build(BuildContext context) {
    final int headCount = context.watch<HeightCalcAppState>().inventory.tripodHeads.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory"),
      ),
      body:
        Consumer<HeightCalcAppState>(
          builder: (_, provider, _) {
          return ListView(
            padding: EdgeInsets.all(20),
            children:[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Heads - $headCount total"),
                    IconButton(
                      icon: Icon(Icons.add_circle),
                      onPressed: () {
                        _addItem(provider.inventory.tripodHeads, provider);
                      },
                    ),  
                  ],
                ),
              Gap(5),
              Column(
                spacing: 5,
                children: provider.inventory.tripodHeads.map((e){
                  return Card(
                    child: ConfigItemTile(item: e, provider: provider));
                  }).toList()
              ),
              Gap(15),
              Center(child: Text("Head Accessories")),
              Gap(5),
              Column(
                spacing: 5,
                children: provider.inventory.headAKS.map((e) {
                  return Card(
                    child: ConfigItemTile(item: e, provider: provider));
                }).toList()
              ),
              Gap(15),
              Center(child: Text("Core Supports")),
              Gap(5),
              Column(
                spacing: 5,
                children: provider.inventory.coreSupports.map((e){
                  return Card(
                    child: ConfigItemTile(item: e, provider: provider));
                  }).toList()
              ),
              Gap(15),
              Center(child: Text("Ground Accessories")),
              Gap(5),
              Column(
                spacing: 5,
                children: provider.inventory.groundAKS.map((e){
                  return Card(
                    child: ConfigItemTile(item: e, provider: provider));
                  }).toList()
              ),
            ],
          );
        }
      ),
    );
  }

  Future<void> _addItem(List<ComplexSupport> list, HeightCalcAppState provider) async {

    final ComplexSupport newItem = ComplexSupport(
      type: list[0].type, // TODO this will fail if there are no other items in the list
      name: "",
      configurations: [
        ComplexSupportConfiguration(minHeight: 0, maxHeight: 0),
      ],
    );

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: IntrinsicWidth(
            child: Column(
              spacing: 5,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Add a new tripod head", style: TextStyle(fontSize: 20),),
                Card(child: ConfigItemTile(item: newItem, provider: provider, newItem: true,)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                print("confirm add item button pressed, attempting to add an item");
                provider.addItem(item: newItem, list: list);
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