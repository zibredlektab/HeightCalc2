import 'package:heightcalc/main.dart';
import 'package:flutter/material.dart';

class AKSSheet extends StatefulWidget {
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