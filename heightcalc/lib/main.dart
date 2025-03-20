import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';


void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
    );
  }
}

class TripodHead {
  final String label;
  final int height; // Mitchell to camera base
  
  TripodHead(this.label, this.height);

  String getLabel() {
    return label;
  }
}

List<TripodHead> heads = [
  TripodHead('2575', 16),
  TripodHead('ArriHead', 22),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _goalHeight = 0;
  TripodHead? _selectedHead = heads.first;
  final TextEditingController _headMenuController = TextEditingController();

  void _calculate(int newHeight) {
    print ('new height is $newHeight');
    setState(() {
      _goalHeight = newHeight;
    });
  }

  void _setHead(TripodHead newHead) {
    print ('new head is ${newHead.label}');
    setState(() {
      _selectedHead = newHead;
    });
  }

  void _showAKSSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
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
                      Text("foo"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {


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
                        _calculate(newHeight);
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
                      _setHead(newHead);
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
                onPressed: () { _showAKSSheet(); },
                child: Text("AKS"),
              ),
              Gap(10),
              Text('$_goalHeight inches to lens, ${_selectedHead?.label} head in use'),
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