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
  var _goalHeight = 0;
  var _selectedHead = heads.first;
  var _selectedAKS = [];

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
    if (_selectedAKS.contains(aksItem)) {
      _selectedAKS.remove(aksItem);
    } else {
      _selectedAKS.add(aksItem);
    }
    notifyListeners();
  }
}

class TripodHead {
  String label;
  int height; // Mitchell to camera base, with no other accessories
  
  TripodHead(this.label, this.height);

  String getLabel() {
    return label;
  }
}

class HeadAccessory {
  // Head Accessories are any item that goes between the Mitchell mount and the camera, besides the head itself
  // This includes Fisher Rotating Offsets, risers, sliders, and Tango heads, for example
  String label;
  int height; // height by which this accessory raises the camera when in use - not necessarily the same as total height of accessory
  bool? canUseBoxes = false; // sliders can be placed directly on apple boxes, for example
  int? heightOnBoxes = 0; // a slider on a box is a different height than on a tripod

  HeadAccessory(this.label, this.height, {this.canUseBoxes, this.heightOnBoxes});
}



List<TripodHead> heads = [
  TripodHead('2575', 16),
  TripodHead('ArriHead', 22),
];

List<HeadAccessory> headAKS = [
  HeadAccessory('Tango', 2),
  HeadAccessory('R-O', 5),
  HeadAccessory('Slider', 6, canUseBoxes: true, heightOnBoxes: 4),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();

  
}

class _HomePageState extends State<HomePage> {

  final TextEditingController _headMenuController = TextEditingController();

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
              Row(
                mainAxisSize: MainAxisSize.min,
                children:[
                  Text("Current head: "),
                  DropdownMenu<TripodHead>(
                    initialSelection: heads.first,
                    hintText: "Select a head",
                    controller: _headMenuController,
                    requestFocusOnTap: true,
                    enableFilter: true,
                    //label: const Text("Head"),
                    inputDecorationTheme: InputDecorationTheme(
                      
                    ),
                    onSelected: (TripodHead? newHead) {
                      newHead ??= heads.first;
                      appState._setHead(newHead);
                    },
                    dropdownMenuEntries:
                      heads.map<DropdownMenuEntry<TripodHead>>((TripodHead head) {
                        return DropdownMenuEntry<TripodHead>(
                          label: head.label,
                          value: head,);
                      }).toList(),
                  )
                ]
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
              Text('$goalHeight inches to lens, ${selectedHead.label} head is in use'),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                    for (var aksItem in appState._selectedAKS) ...[
                      if (aksItem != appState._selectedAKS.first && appState._selectedAKS.length > 2)
                        Text(','),
                      if (aksItem == appState._selectedAKS.last && appState._selectedAKS.length >= 2)
                        Text(' and'),
                      Text(' ${aksItem.label}'),
                    ],
                    if (appState._selectedAKS.length > 1)
                      Text(' are in use'),
                    if (appState._selectedAKS.length == 1)
                      Text(' is in use'),
                ],
                
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


class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Config')),
      body: ListView(
        children: [Text('foo'),],
      )
    );
  }
}

class AKSBottomSheet extends StatefulWidget {
  @override
  AKSBottomSheetState createState() => AKSBottomSheetState();
}

class AKSBottomSheetState extends State<AKSBottomSheet> {
  var selectedAKS = [];
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    selectedAKS = appState._selectedAKS;
    return Center(
      child: Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children:[
            Center(
              child: Column(
                children:[
                  Text("Required Accessories", style: Theme.of(context).textTheme.headlineMedium!),
                  Gap(5),
                  Text("Select the accessories you intend to use for this setup.", textAlign: TextAlign.center,),
                  for (var headAKSItem in headAKS)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 110),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(headAKSItem.label),
                          Switch(value: selectedAKS.contains(headAKSItem), onChanged: (bool value) {
                            appState._toggleAKS(headAKSItem);
                            print('AKS item ${headAKSItem.label} has been toggled ${appState._selectedAKS.contains(headAKSItem)}.');
                          })
                        ],
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}