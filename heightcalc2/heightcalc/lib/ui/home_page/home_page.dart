import 'package:heightcalc/data_types/data_types.dart';
import 'package:heightcalc/main.dart';
import 'package:heightcalc/ui/aks_sheet/aks_sheet.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<HeightCalcAppState>();
    var selectedHead = appState.inventory.currentHead;
    var goalHeight = appState.calc.shotHeight;

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
                        appState.newHeight(newHeight);
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
                      if (appState.inventory.tripodHeads.isEmpty) ...[
                        Text("No heads defined!")
                      ] else ...[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButton<TripodHead>(
                            value: provider.inventory.currentHead,
                            underline: Container(), // get rid of that underline
                            hint: Text('Select a head'),
                            onChanged: (TripodHead? newHead) {
                              newHead ??= provider.inventory.tripodHeads.first;
                              appState.setHead(newHead);
                            },
                            borderRadius: BorderRadius.circular(5),
                            isDense: false,
                            items: provider.inventory.tripodHeads.map<DropdownMenuItem<TripodHead>>((TripodHead head) {
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
                    builder: (_) => AKSSheet(),
                  );
                },
                child: Text("Shot Setup"),
              ),
              Gap(10),
              Consumer<HeightCalcAppState>(
                builder: (context, provider, child) {
                  return Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            for (var aksItem in provider.inventory.requiredAKS) ...[
                              if (aksItem != provider.inventory.requiredAKS.first && provider.inventory.requiredAKS.length > 2)
                                Text(','),
                              if (aksItem == provider.inventory.requiredAKS.last && provider.inventory.requiredAKS.length >= 2)
                                Text(' and'),
                              Text(' ${aksItem.name}'),
                            ],
                            if (provider.inventory.requiredAKS.length > 1)
                              Text(' are in use'),
                            if (provider.inventory.requiredAKS.length == 1)
                              Text(' is in use'),
                        ],
                      ),
                      if (provider.solutions.isNotEmpty)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children:[
                            if (provider.solutions.isNotEmpty) ...[
                              Text("Solutions:", style: TextStyle(fontWeight: FontWeight.bold),),
                              Gap(5),
                              ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                children: provider.solutionsByComplexity(),
                              ),
                            ]
                          ],
                        )
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