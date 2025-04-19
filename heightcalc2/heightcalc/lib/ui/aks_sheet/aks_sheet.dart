import 'package:heightcalc/data_types/generic/complex_support_configuration.dart';
import 'package:heightcalc/main.dart';

class AKSSheet extends StatefulWidget {
  const AKSSheet({super.key});

  @override
  AKSSheetState createState() => AKSSheetState();
}

class AKSSheetState extends State<AKSSheet> {
  var selectedHeadAKS = [];
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<HeightCalcAppState>();
    selectedHeadAKS = appState.inventory.requiredAKS;
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children:[
                          Text("Current head configuration: "),
                          if (appState.inventory.currentHead == null) ...[
                            Text("(No head selected)"),
                          ] else ...[
                            DropdownMenu<ComplexSupportConfiguration>(
                              initialSelection: provider.inventory.currentHeadConfig,
                              hintText: 'Select a head configuration',
                              onSelected: (ComplexSupportConfiguration? newConfig) {
                                newConfig ??= provider.inventory.tripodHeads.first.configurations.first;
                                provider.setHeadConfig(newConfig);
                              },
                              dropdownMenuEntries: provider.inventory.currentHead!.configurations.map<DropdownMenuEntry<ComplexSupportConfiguration>>((ComplexSupportConfiguration config) {
                                return DropdownMenuEntry<ComplexSupportConfiguration>(
                                  value: config,
                                  label: config.name,
                                );
                              }).toList(),
                            ),
                          ]
                        ]
                      ),
                      Text("Required Accessories", style: Theme.of(context).textTheme.headlineMedium!),
                      Gap(5),
                      Text("Select the accessories you intend to use for this setup.", textAlign: TextAlign.center,),
                      for (var headAKSItem in provider.inventory.headAKS)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 110),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(headAKSItem.name),
                              Switch(value: selectedHeadAKS.contains(headAKSItem), onChanged: (bool value) {
                                provider.toggleRequiredAKS(headAKSItem);
                                print('AKS item ${headAKSItem.name} has been toggled ${provider.inventory.requiredAKS.contains(headAKSItem)}.');
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