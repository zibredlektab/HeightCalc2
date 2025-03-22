// ignore_for_file: unnecessary_import

import 'dart:ffi';
import 'dart:ui';

import 'package:heightcalc/imports.dart';

void main() {
  runApp(const HeightCalcApp());
}

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

class HeightCalcApp extends StatelessWidget {
  const HeightCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HeightCalcAppState(),
      child: MaterialApp(
        title: 'HeightCalc',
        navigatorKey: navKey,
        home: const HomePage(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        ),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        routes: {
          '/config': (context) => const ConfigPage(),
        }
      ),
    );
  }
}

class HeightCalcAppState extends ChangeNotifier {
  List<TripodHead> heads = [
    TripodHead('2575', 16),
    TripodHead('ArriHead', 22),
  ];

  List<HeadAccessory> headAKS = [
    HeadAccessory('tango', 2),
    HeadAccessory('R-O', 5),
    HeadAccessory('slider', 6, canUseBoxes: true, heightOnBoxes: 4),
  ];

  List<CoreSupport> coreSupports = [
    CoreSupport('lo-hat', height: 3),
    CoreSupport('hi-hat', height: 6),
    CoreSupport('babies', minHeight: 20, maxHeight: 36),
    CoreSupport('standards', minHeight: 36, maxHeight: 66),
    CoreSupport('Fischer 11 standard', minHeight: 14, maxHeight: 51),
    CoreSupport('Fischer 11 low mode', minHeight: 3, maxHeight: 39),
  ];

  List<GroundSupport> groundSupports = [
    GroundSupport('full apple #3', 20),
    GroundSupport('full apple #2', 12),
    GroundSupport('full apple #1', 8),
    GroundSupport('half-apple', 4),
    GroundSupport('quarter-apple', 2),
    GroundSupport('pancake', 1),
    GroundSupport('rollers', 4, worksWith: ['babies', 'standards']),
    
  ];

  var goalHeight = 0; // total height from ground to lens
  TripodHead? selectedHead; // tripod head currently in use
  var selectedHeadAKS = [];

  HeightCalcAppState() {
    selectedHead = heads.first;
  }

  void calculate(int newHeight) {
    print ('new height is $newHeight');
    goalHeight = newHeight;
    notifyListeners();
  }

  void setHead(TripodHead newHead) {
    print ('new head is ${newHead.name}');
    selectedHead = newHead;
    notifyListeners();
  }

  void toggleAKS(HeadAccessory aksItem) {
    if (selectedHeadAKS.contains(aksItem)) {
      selectedHeadAKS.remove(aksItem);
    } else {
      selectedHeadAKS.add(aksItem);
    }
    notifyListeners();
  }

  void updateAKSName(List<AKS> list, String oldName, String newName) {
    AKS toReplace = list.firstWhere((i) => i.name.toLowerCase().contains(oldName.toLowerCase()));
    toReplace.setName(newName);
    notifyListeners();
  }
  void updateAKSHeight(List<AKS> list, String name, int newHeight) {
    AKS toReplace = list.firstWhere((i) => i.name.toLowerCase().contains(name.toLowerCase()));
    toReplace.setHeight(newHeight);
    notifyListeners();
  }
}
