// ignore_for_file: unnecessary_import

import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
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

class MyAppState extends ChangeNotifier {
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

  var _goalHeight = 0; // total height from ground to lens
  TripodHead? _selectedHead; // tripod head currently in use
  var _selectedHeadAKS = [];

  MyAppState() {
    _selectedHead = heads.first;
  }

  void _calculate(int newHeight) {
    print ('new height is $newHeight');
    _goalHeight = newHeight;
    notifyListeners();
  }

  void _setHead(TripodHead newHead) {
    print ('new head is ${newHead.label}');
    _selectedHead = newHead;
    notifyListeners();
  }

  void _toggleAKS(HeadAccessory aksItem) {
    if (_selectedHeadAKS.contains(aksItem)) {
      _selectedHeadAKS.remove(aksItem);
    } else {
      _selectedHeadAKS.add(aksItem);
    }
    notifyListeners();
  }

  void updateAKS(List<AKS> list, AKS oldItem, AKS newItem) {
    AKS toReplace = list.firstWhere((i) => i.label.toLowerCase().contains(oldItem.label.toLowerCase()));
    list.remove(toReplace);
    list.add(newItem);
    notifyListeners();
  }

  void updateHeadName(String oldName, String newName) {
    TripodHead toReplace = heads.firstWhere((i) => i.label.toLowerCase().contains(oldName.toLowerCase()));
    toReplace.label = newName;
    notifyListeners();
  }
}

class AKS {
  String label = "";
  int height = 0;
}

class TripodHead extends AKS {
  // Height is itchell to camera base, with no other accessories
  
  TripodHead(label, height) {
    super.label = label;
    super.height = height;
  }

  String getLabel() {
    return label;
  }
}

class HeadAccessory extends AKS{
  // Head Accessories are any item that goes between the Mitchell mount and the camera, besides the head itself
  // This includes Fisher Rotating Offsets, risers, sliders, and Tango heads, for example
  // Height is height by which this accessory raises the camera when in use - not necessarily the same as total height of accessory
  bool? canUseBoxes = false; // sliders can be placed directly on apple boxes, for example
  int? heightOnBoxes = 0; // a slider on a box is a different height than on a tripod

  HeadAccessory(label, height, {this.canUseBoxes, this.heightOnBoxes}){
    super.label = label;
    super.height = height;
  }
}

class CoreSupport extends AKS {
  // Core Supports are the main supporting element of the camera setup, usually the item that the tripod head mounts to
  // Examples: tripods, dollys, hi-hats
  // Height is for non-adjustable core supports, the height from the bottom of this accessory to its Mitchell mount
  int? minHeight = 0; // lowest height for adjustable core supports (tripods which can raise/lower etc)
  int? maxHeight = 0; // highest etc

  CoreSupport(label, {height, this.minHeight, this.maxHeight}) {
    super.label = label;
    if (height != null && (minHeight == null || maxHeight == null)) {
      minHeight = height;
      maxHeight = height;
    }
    height ??= 0;
    super.height = height;
  }
}

class GroundSupport extends AKS {
  // Ground Supports are items that go underneath Core Supports.
  // Examples: apple boxes, rolling spreaders, dolly track

  List<String>? worksWith = []; // not all ground support is compatible with every core support (rollers don't work with dollys)

  GroundSupport(label, height, {this.worksWith}) {
    super.label = label;
    super.height = height;
  
    /*if (worksWith == null || worksWith?.length == 0) {
      // if worksWith is not provided, assume it works with everything
      worksWith = [];
      for (var i in coreSupports) {
        worksWith?.add(i.label);
      }
    }*/
  }
}



class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();

  
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {

    var appState = context.watch<MyAppState>();
    var selectedHead = appState._selectedHead;
    var goalHeight = appState._goalHeight;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Height Calc')),
        body: Center(
          child: Column(
            children:[
              Gap(10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children:[
                  Text("Desired lens height: "),
                  SizedBox(
                    width: 100,
                    child: TextFormField(                    
                      decoration: InputDecoration(border: OutlineInputBorder(), hintText: "0", helperText: "inches",),
                      autocorrect: false,
                      autofocus: true,
                      canRequestFocus: true,
                      enableSuggestions: false,
                      enableInteractiveSelection: false,
                      keyboardType: TextInputType.number,
                      onChanged: (String? inputValue) {
                        int newHeight = 0;
                        inputValue ??= "0"; // protect against null cases
                        try {
                          newHeight = int.parse(inputValue);
                        } catch(e) {
                          print('invalid number provided');
                        }
                        appState._calculate(newHeight);
                      },
                    ),
                  ),
                ]
              ),
              Gap(10),
              Consumer<MyAppState>(
                builder: (context, provider, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children:[
                      Text("Current head: "),
                      if (appState.heads.isEmpty) ...[
                        Text("No heads defined!")
                      ] else ...[
                        DropdownButton<TripodHead>(
                          value: provider._selectedHead,
                          hint: Text('Select a head'),
                          onChanged: (TripodHead? newHead) {
                            newHead ??= provider.heads.first;
                            appState._setHead(newHead);
                          },
                          
                          items: [
                            for (var head in provider.heads) ...[
                              DropdownMenuItem<TripodHead>(
                                value: head,
                                child: Text(head.label),
                              ),
                            ]
                          ],
                        ),
                      ]
                    ]
                  );
                }
              ),
              Gap(10),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (_) => AKSBottomSheet(),
                  );
                },
                child: Text("AKS"),
              ),
              Gap(10),
              Text('$goalHeight inches to lens, ${selectedHead?.label} head is in use'),
              Consumer<MyAppState>(
                builder: (context, provider, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        for (var aksItem in provider._selectedHeadAKS) ...[
                          if (aksItem != provider._selectedHeadAKS.first && provider._selectedHeadAKS.length > 2)
                            Text(','),
                          if (aksItem == provider._selectedHeadAKS.last && provider._selectedHeadAKS.length >= 2)
                            Text(' and'),
                          Text(' ${aksItem.label}'),
                        ],
                        if (provider._selectedHeadAKS.length > 1)
                          Text(' are in use'),
                        if (provider._selectedHeadAKS.length == 1)
                          Text(' is in use'),
                    ],
                  );
                }
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navKey.currentState?.pushNamed('/config');
          },
          child: const Text('Config'),
        ),
      ),
    );
  }
}


class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});
  @override
  State<ConfigPage> createState() => _ConfigPageState();

  
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Config')),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: [
              Center(
                child: Consumer<MyAppState>(
                  builder: (context, provider, child) {
                    return Column(
                      children: [
                        Text('Heads', style: Theme.of(context).textTheme.headlineSmall!),
                        Gap(20),
                        for (var headItem in provider.heads) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 110),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 250,
                                  child: TextField(
                                    decoration: InputDecoration(border: OutlineInputBorder(), hintText: headItem.label, helperText: "Head Name",),
                                    autocorrect: false,
                                    onSubmitted: (String? inputValue) {
                                      inputValue ??= headItem.label;
                                      provider.updateHeadName(headItem.label, inputValue);
                                      for (var i in provider.heads) {
                                        print ('${i.label} ,');
                                      }
                                    },
                                  ),
                                ),
                                Text('${headItem.height}'),
                              ]
                            ),
                          ),
                          Gap(20),
                        ],
                      ],
                    );
                  }
                )
              ),
            ],
          ),
        ),
      )
    );
  }
}

class AKSBottomSheet extends StatefulWidget {
  @override
  AKSBottomSheetState createState() => AKSBottomSheetState();
}

class AKSBottomSheetState extends State<AKSBottomSheet> {
  var selectedHeadAKS = [];
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    selectedHeadAKS = appState._selectedHeadAKS;
    return Center(
      child: Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children:[
            Center(
              child: Consumer<MyAppState>(
                builder: (context, provider, child) {
                  return Column(
                    children:[
                      Text("Required Accessories", style: Theme.of(context).textTheme.headlineMedium!),
                      Gap(5),
                      Text("Select the accessories you intend to use for this setup.", textAlign: TextAlign.center,),
                      for (var headAKSItem in provider.headAKS)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 110),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(headAKSItem.label),
                              Switch(value: selectedHeadAKS.contains(headAKSItem), onChanged: (bool value) {
                                provider._toggleAKS(headAKSItem);
                                print('AKS item ${headAKSItem.label} has been toggled ${provider._selectedHeadAKS.contains(headAKSItem)}.');
                              })
                            ],
                          ),
                        )
                    ],
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}