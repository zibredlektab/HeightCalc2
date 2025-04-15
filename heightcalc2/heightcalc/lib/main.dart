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
      child: const HeightCalcApp()),
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
      ComplexSupport(type: SupportType.tripodHead, name: "2575", configurations: [
        ComplexSupportConfiguration(minHeight: 16, maxHeight: 16),
      ]),
      ComplexSupport(type: SupportType.tripodHead, name: "ArriHead", configurations: [
        ComplexSupportConfiguration(minHeight: 22, maxHeight: 22),
        ComplexSupportConfiguration(name: "with tilt plate", minHeight: 24, maxHeight: 24),
        
      ]),
    ];
    inventory.currentHead = inventory.tripodHeads.first;

    inventory.coreSupports = [
      ComplexSupport(
        type: SupportType.coreSupport, name: "Mika", configurations: [
          ComplexSupportConfiguration(name: "Standing", minHeight: 60, maxHeight: 60),
          ComplexSupportConfiguration(name: "Sitting", minHeight: 40, maxHeight: 40),
        ]
      ),
      ComplexSupport(
        type: SupportType.coreSupport, name: "Lo-Hat", configurations: [
          ComplexSupportConfiguration(minHeight: 3, maxHeight: 3),
        ]
      ),
      ComplexSupport(
        type: SupportType.coreSupport, name: "Hi-Hat", configurations: [
          ComplexSupportConfiguration(minHeight: 6, maxHeight: 6),
        ]
      ),
      ComplexSupport(
        type: SupportType.coreSupport, name: "Babies", configurations: [
          ComplexSupportConfiguration(name: "Flat Spreaders", minHeight: 20, maxHeight: 36),
          ComplexSupportConfiguration(name: "Rolling Spreaders", minHeight: 24, maxHeight: 40),
        ]
      ),
      ComplexSupport(
        type: SupportType.coreSupport, name: "Standards", configurations: [
          ComplexSupportConfiguration(name: "Flat Spreaders", minHeight: 36, maxHeight: 66),
          ComplexSupportConfiguration(name: "Rolling Spreaders", minHeight: 40, maxHeight: 70),
        ]
      ),
    ];

    inventory.headAKS = [
      ComplexSupport(type: SupportType.headAKS, name: "Tango", configurations: [
        ComplexSupportConfiguration(minHeight: 2, maxHeight: 2)
      ]),
      ComplexSupport(type: SupportType.headAKS, name: "Slider", configurations: [
        ComplexSupportConfiguration(minHeight: 6, maxHeight: 6),
        ComplexSupportConfiguration(name: "On Boxes", minHeight: 4, maxHeight: 4),
      ]),
      ComplexSupport(type: SupportType.headAKS, name: "R-O", configurations: [
        ComplexSupportConfiguration(minHeight: 5, maxHeight: 5),
      ]),
    ];

    inventory.groundAKS = [
      ComplexSupport(
        type: SupportType.groundAKS, name: "Full Apple", configurations: [
          ComplexSupportConfiguration(name: "#3", minHeight: 20, maxHeight: 20, canStack: false),
          ComplexSupportConfiguration(name: "#2", minHeight: 12, maxHeight: 12, canStack: false),
          ComplexSupportConfiguration(name: "#1", minHeight: 8, maxHeight: 8),
        ]
      ),
      ComplexSupport(
        type: SupportType.groundAKS, name: "Half Apple", configurations: [
          ComplexSupportConfiguration(minHeight: 6, maxHeight: 6),
        ]
      ),
      ComplexSupport(
        type: SupportType.groundAKS, name: "Quarter Apple", configurations: [
          ComplexSupportConfiguration(minHeight: 3, maxHeight: 3),
        ]
      ),
      ComplexSupport(
        type: SupportType.groundAKS, name: "Pancake", configurations: [
          ComplexSupportConfiguration(minHeight: 1, maxHeight: 1),
        ]
      ),
    ];
  }

  void setHead(ComplexSupport newHead) {
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

    notifyListeners();
  }

  void toggleRequiredAKS(ComplexSupport item) {
    if (inventory.requiredAKS.contains(item)) {
      inventory.requiredAKS.remove(item);
    } else {
      inventory.requiredAKS.add(item);
    }
    notifyListeners();
  }

  void update() {
    if (inventory.currentHead != null) {
      newHeight(calc.shotHeight);
    }

    notifyListeners();
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

    item.newItem = false;

    update();
  }

  void removeItem(ComplexSupport item) {

    if (inventory.currentHead == item) {
      inventory.currentHead = null;
    }

    List<ComplexSupport> list = getListForItem(item);
    list.remove(item);

    print("Removed item ${item.name} from list $list");
    

    update();
  }

  void addItem({
      String? name,
      List<ComplexSupportConfiguration> configs = const [],
      ComplexSupport? item,
      required List<ComplexSupport> list,
    }) {
    if (item != null) {
      list.insert(0, item);
    } else if (name != null && configs.isNotEmpty) {
      list.insert(0, ComplexSupport(type: list[0].type, name: name, configurations: configs)); // TODO this will fail if there are no other items in the list
    } else {
      print("Something went wrong attempting to add an item to a list");
    }

    update();
  }

  void removeConfig({
      required ComplexSupport item,
      required ComplexSupportConfiguration config
    }) {
    if (item.configurations.contains(config)) {
      item.configurations.remove(config);
    }
    update();
  }

  List<ComplexSupport> getListForItem(ComplexSupport item) {
    return getListForType(item.type);
  }

  List<ComplexSupport> getListForType(SupportType type) {
    switch(type) {
      case SupportType.tripodHead: {
        return inventory.tripodHeads;
      }
      case SupportType.headAKS: {
        return inventory.headAKS;
      }
      case SupportType.groundAKS: {
        return inventory.groundAKS;
      }
      case SupportType.coreSupport: {
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
