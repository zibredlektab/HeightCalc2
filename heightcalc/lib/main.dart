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
      //darkTheme: ThemeData.dark(),
      //themeMode: ThemeMode.system,
      //initialRoute: '/',
      routes: {
        '/config': (context) => const ConfigPage(),
      }
    );
  }
}

/*
typedef HeadEntry = DropdownMenuEntry<Head>;
enum Head {
  2575('2575', 16),
  arrihead('ArriHead', 22),

  final String label;
  final int headHeight;

  static final List<HeadEntry> entries = UnmodifiableListView<HeadEntry>(
    values.map<HeadEntry>(
      (Head headHeight) => HeadEntry(
        value: headHeight,
        label: label,
      )
    )
  )
}*/

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

  void _calculate(int newHeight) {
    print ('new height is $newHeight');
    setState(() {
      _goalHeight = newHeight;
    });
  }

  void setHead(TripodHead newHead) {

  }

  @override
  Widget build(BuildContext context) {

    final TextEditingController textEditingController = TextEditingController();

    return Scaffold(
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
                    initialValue:'0',
                    decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'inches',),
                    autocorrect: false,
                    autofocus: true,
                    enableSuggestions: false,
                    enableInteractiveSelection: false,
                    keyboardType: TextInputType.number,
                    onChanged: (String? inputValue) async {
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
                  controller: textEditingController,
                  requestFocusOnTap: true,
                  label: Text('${_selectedHead?.label}'),
                  onSelected: (TripodHead? newHead) {
                    newHead ??= heads.first;
                    setState(() {
                      _selectedHead = newHead;
                    });
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