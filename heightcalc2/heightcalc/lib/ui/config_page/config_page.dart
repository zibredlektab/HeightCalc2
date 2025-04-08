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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Config"),
      ),
      body: 
        Consumer<HeightCalcAppState>(
          builder: (context, provider, child) {
          return Center(
            child: ListView(
              padding: EdgeInsets.all(20),
              children:[
                Center(child: Text("Heads")),
                Gap(5),
                for (var i in provider.inventory.tripodHeads) ...[
                  Card(
                    child: ConfigItemTile(item: i),
                  ),
                  Gap(5),
                ],
                Gap(15),
                Center(child: Text("Head Accessories")),
                Gap(5),
                for(var i in provider.inventory.headAKS) ...[
                  Card(
                    child: ConfigItemTile(item: i, provider: provider,),
                  ),
                  Gap(5),
                ],
                Gap(15),
                Center(child: Text("Core Supports")),
                Gap(5),
                for(var i in provider.inventory.coreSupports) ...[
                  Card(
                    child: ConfigItemTile(item: i),
                  ),
                  Gap(5),
                ],
                Gap(15),
                Center(child: Text("Ground Accessories")),
                Gap(5),
                for(var i in provider.inventory.groundAKS) ...[
                  Card(
                    child: ConfigItemTile(item: i),
                  ),
                  Gap(5),
                ],
              ],
            )
          );
        }
      ),
    );
  }
}