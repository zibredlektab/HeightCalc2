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
                        _addItem(SupportType.tripodHead, provider);
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

  Future<void> _addItem(SupportType type, HeightCalcAppState provider) async {

    final ComplexSupport newItem = ComplexSupport(
      type: type,
      name: "New Item",
      configurations: [
        ComplexSupportConfiguration(minHeight: 0, maxHeight: 0),
      ],
      newItem: true,
    );

    final List<ComplexSupport> list = provider.getListForType(type);
    
    provider.addItem(item: newItem, list: list);
  }




}