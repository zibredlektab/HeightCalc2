import 'package:flutter/material.dart';
import 'package:heightcalc/calculator.dart';
import 'package:heightcalc/data_types/data_types.dart';
import 'package:heightcalc/data_types/generic/complex_support_configuration.dart';
import 'package:heightcalc/inventory.dart';
import 'package:heightcalc/solution_model.dart';
import 'package:heightcalc/ui/solution.dart';
import 'package:provider/provider.dart';
import 'package:heightcalc/app_global.dart';
import 'package:heightcalc/ui/home_page/home_page.dart';
import 'package:heightcalc/ui/config_page/config_page.dart';
export 'package:flutter/material.dart';
export 'package:gap/gap.dart';
export 'package:provider/provider.dart';
export 'package:heightcalc/app_global.dart';




void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HeightCalcAppState(),
        ),
      ],
      child: HeightCalcApp()),
  );
}

class HeightCalcAppState extends ChangeNotifier {
  
  late Inventory inventory;
  late Calculator calc;
  late List<Solution> solutions;

  HeightCalcAppState() {
    inventory = Inventory();
    calc = Calculator(inventory);
    inventory.setBaseHeight(6);
    solutions = [];

    inventory.tripodHeads = [
      TripodHead(name: "2575", configurations: [
        ComplexSupportConfiguration(minHeight: 16, maxHeight: 16),
      ]),
      TripodHead(name: "ArriHead", configurations: [
        ComplexSupportConfiguration(minHeight: 22, maxHeight: 22),
        ComplexSupportConfiguration(name: "with tilt plate", minHeight: 24, maxHeight: 24),
        
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

    inventory.headAKS = [
      HeadAKS(name: "Tango", configurations: [
        ComplexSupportConfiguration(minHeight: 2, maxHeight: 2)
      ]),
      HeadAKS(name: "Slider", configurations: [
        ComplexSupportConfiguration(minHeight: 6, maxHeight: 6),
        ComplexSupportConfiguration(name: "On Boxes", minHeight: 4, maxHeight: 4),
      ]),
      HeadAKS(name: "R-O", configurations: [
        ComplexSupportConfiguration(minHeight: 5, maxHeight: 5),
      ]),
    ];

    inventory.groundAKS = [
      GroundAKS(
        name: "Full Apple", configurations: [
          ComplexSupportConfiguration(name: "#3", minHeight: 20, maxHeight: 20, canStack: false),
          ComplexSupportConfiguration(name: "#2", minHeight: 12, maxHeight: 12, canStack: false),
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
  }

  void setHead(TripodHead newHead) {
    inventory.currentHead = newHead;
    notifyListeners();
  }

  void newHeight(int height) {
    print("Getting new list of solutions for height of $height");
    List<SolutionModel>models = calc.calculateHeight(height);
    solutions = [];
    for (var i in models) {
      solutions.add(Solution(model: i));
    }
    super.notifyListeners();
  }

  void toggleRequiredAKS(ComplexSupport item) {
    if (inventory.requiredAKS.contains(item)) {
      inventory.requiredAKS.remove(item);
    } else {
      inventory.requiredAKS.add(item);
    }
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (inventory.currentHead != null) {
      newHeight(calc.shotHeight);
    }
    super.notifyListeners;
  }

  List<Solution> solutionsByComplexity() {
    List<Solution> sortedList = List.from(solutions);
    sortedList.sort((a,b) => a.length.compareTo(b.length));
    return sortedList;
  }

  void updateItem(ComplexSupport item, {String name = "", List<ComplexSupportConfiguration> configs = const []}) {
    // Update the specified item with the specified parameters
    if (name != "") {
      item.name = name;
    }

    if (configs.isNotEmpty) {
      item.configurations = configs;
    }

    notifyListeners();
  }

  void removeItem(ComplexSupport item) {

    if (inventory.currentHead == item) {
      inventory.currentHead = null;
    }

    List<ComplexSupport> list = _getListforItem(item);
    list.remove(item);

    print("Removed item ${item.name} from list $list");

    notifyListeners();
  }

  List<ComplexSupport> _getListforItem(ComplexSupport item) {
    switch(item.runtimeType) {
      case TripodHead: {
        return inventory.tripodHeads;
      }
      case HeadAKS: {
        return inventory.headAKS;
      }
      case GroundAKS: {
        return inventory.groundAKS;
      }
      case ComplexSupport: {
        return inventory.coreSupports;
      }
      default:
        return inventory.coreSupports;

    }
  }
}

class HeightCalcApp extends StatelessWidget {
  const HeightCalcApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'HeightCalc',
      navigatorKey: AppGlobal.navKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      routes: {
        '/': (context) => const HomePage(),
        '/config': (context) => const ConfigPage(),
      },
    );
  }
}
