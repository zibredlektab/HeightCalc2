import 'package:flutter/material.dart';
import 'package:heightcalc/main.dart';
import 'package:gap/gap.dart';

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Heads"),
                  ]
                ),
                Gap(5),
                for (var i in provider.inventory.tripodHeads) ...[
                  Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      title: Text('${i.name}: ${i.configurations[0].minHeight} inches'),
                    ),
                  ),
                  Gap(5),
                ]
              ],
            )
          );
        }
      ),
    );
  }
}