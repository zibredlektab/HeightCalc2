import 'package:flutter/material.dart';
import 'package:heightcalc/calculator.dart';
import 'package:heightcalc/data_types/data_types.dart';
import 'package:heightcalc/data_types/generic/complex_support_configuration.dart';
import 'package:heightcalc/inventory.dart';
import 'package:heightcalc/solution_model.dart';


late Inventory inventory;
late Calculator calc;
late List<SolutionModel> solutions;

void main() {
  Inventory inventory = Inventory();

  inventory.setBaseHeight(6);

  calc = Calculator(inventory);

  inventory.tripodHeads = [
    TripodHead(name: "2575", configurations: [
      ComplexSupportConfiguration(minHeight: 16, maxHeight: 16),
    ]),
  ];
  inventory.currentHead = inventory.tripodHeads.first;

  inventory.coreSupports = [
    ComplexSupport(
      name: "Lo-Hat", configurations: [
        ComplexSupportConfiguration(minHeight: 3, maxHeight: 3),
      ]
    ),
    ComplexSupport(
      name: "Hi-Hat", configurations: [
        ComplexSupportConfiguration(minHeight: 6, maxHeight: 6),
      ]
    ),
    ComplexSupport(
      name: "Babies", configurations: [
        ComplexSupportConfiguration(name: "Flat Spreaders", minHeight: 20, maxHeight: 36),
        ComplexSupportConfiguration(name: "Rolling Spreaders", minHeight: 24, maxHeight: 40),
      ]
    ),
    ComplexSupport(
      name: "Standards", configurations: [
        ComplexSupportConfiguration(name: "Flat Spreaders", minHeight: 36, maxHeight: 66),
        ComplexSupportConfiguration(name: "Rolling Spreaders", minHeight: 40, maxHeight: 70),
      ]
    ),
  ];

  inventory.groundAKS = [
    GroundAKS(
      name: "Full Apple", configurations: [
        ComplexSupportConfiguration(name: "#3", minHeight: 20, maxHeight: 20),
        ComplexSupportConfiguration(name: "#2", minHeight: 12, maxHeight: 12),
        ComplexSupportConfiguration(name: "#1", minHeight: 8, maxHeight: 8),
      ]
    ),
    GroundAKS(
      name: "Half Apple", configurations: [
        ComplexSupportConfiguration(minHeight: 6, maxHeight: 6),
      ]
    ),
    GroundAKS(
      name: "Quarter Apple", configurations: [
        ComplexSupportConfiguration(minHeight: 3, maxHeight: 3),
      ]
    ),
    GroundAKS(
      name: "Pancake", configurations: [
        ComplexSupportConfiguration(minHeight: 1, maxHeight: 1),
      ]
    ),
  ];

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    solutions = calc.calculateHeight(78);

    var text = "";
    for (var i in solutions) {
      text += "${i.getList()}\n\n";
    }

    return MaterialApp( 
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text("78 inches:"),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
