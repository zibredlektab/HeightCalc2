import 'package:flutter/material.dart';
import 'package:heightcalc/main.dart';

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
      body: Center(child: Text("Config"),),
    );
  }
}