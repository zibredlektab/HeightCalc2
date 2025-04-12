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
    print ("Rebuilding config page, $headCount heads total:");
    for (var head in context.read<HeightCalcAppState>().inventory.tripodHeads) {
      print (head.name);
    }

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
              Center(child: Text("Heads - $headCount total")),
              Gap(5),
              Column(
                spacing: 5,
                children: provider.inventory.tripodHeads.map((e){
                  String thelist = "";
                  for (var i in provider.inventory.tripodHeads) {
                    thelist += "${i.name}, ";
                  }
                  print("This list now contains ${provider.inventory.tripodHeads.length} items: $thelist");
                  print("Making a new card for item ${e.name}");
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
}