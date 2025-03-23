// ignore_for_file: unnecessary_import

import 'package:heightcalc/imports.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();  
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    var appState = context.watch<HeightCalcAppState>();
    var selectedHead = appState.selectedHead;
    var goalHeight = appState.goalHeight;

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
                        appState.calculate(newHeight);
                      },
                    ),
                  ),
                ]
              ),
              Gap(10),
              Consumer<HeightCalcAppState>(
                builder: (context, provider, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children:[
                      Text("Current head: "),
                      if (appState.heads.isEmpty) ...[
                        Text("No heads defined!")
                      ] else ...[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButton<TripodHead>(
                            value: provider.selectedHead,
                            underline: Container(), // get rid of that underline
                            hint: Text('Select a head'),
                            onChanged: (TripodHead? newHead) {
                              newHead ??= provider.heads.first;
                              appState.setHead(newHead);
                            },
                            borderRadius: BorderRadius.circular(5),
                            isDense: false,
                            items: provider.heads.map<DropdownMenuItem<TripodHead>>((TripodHead head) {
                              return DropdownMenuItem<TripodHead>(
                                value: head,
                                child: Text(head.name),
                              );
                            }).toList(),
                          ),
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
              Text('$goalHeight inches to lens, ${selectedHead?.name} head is in use'),
              Consumer<HeightCalcAppState>(
                builder: (context, provider, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        for (var aksItem in provider.selectedHeadAKS) ...[
                          if (aksItem != provider.selectedHeadAKS.first && provider.selectedHeadAKS.length > 2)
                            Text(','),
                          if (aksItem == provider.selectedHeadAKS.last && provider.selectedHeadAKS.length >= 2)
                            Text(' and'),
                          Text(' ${aksItem.name}'),
                        ],
                        if (provider.selectedHeadAKS.length > 1)
                          Text(' are in use'),
                        if (provider.selectedHeadAKS.length == 1)
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
            AppGlobal.navKey.currentState?.pushNamed('/config');
          },
          child: const Text('Config'),
        ),
      ),
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
    var appState = context.watch<HeightCalcAppState>();
    selectedHeadAKS = appState.selectedHeadAKS;
    return Center(
      child: Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children:[
            Center(
              child: Consumer<HeightCalcAppState>(
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
                              Text(headAKSItem.name),
                              Switch(value: selectedHeadAKS.contains(headAKSItem), onChanged: (bool value) {
                                provider.toggleAKS(headAKSItem);
                                print('AKS item ${headAKSItem.name} has been toggled ${provider.selectedHeadAKS.contains(headAKSItem)}.');
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