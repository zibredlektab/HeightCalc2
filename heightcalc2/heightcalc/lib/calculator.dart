import 'package:heightcalc/data_types/data_types.dart';
import 'package:heightcalc/data_types/generic/complex_support_configuration.dart';
import 'package:heightcalc/solution_model.dart';
import 'package:heightcalc/inventory.dart';

class Calculator {
  Inventory inventory;
  int baseHeight = 0; // Base of camera to center of lens
  int shotHeight = 0; // Desired height of lens for this particular setup
  int mountHeight = 0; // How much height is left to account for (this diminishes as we add support items below) 
  List<SolutionModel> _currentSolutions = []; // The list of all valid solutions for the requested shotHeight

  Calculator(this.inventory) {
    baseHeight = inventory.baseHeight;
  }

  List<SolutionModel> calculateHeight (int height) {
    /* subtract baseheight and current head height from shotheight
        then, subtract all required aks from shotheight
        the remaining value is the height we need to acheive
        cycle through the tripods, dollys, and generic support to find supports that are below the desired height
        then work out what aks are available to add onto these (rollers / appleboxes / risers)
        finally, build a solutionmodel for each valid solution, ordered by preference
    */
    removeAllSolutions(); // Start from scratch

    shotHeight = height;
    mountHeight = shotHeight - baseHeight; // camera height
    mountHeight -= inventory.currentHead!.configurations.first.minHeight; // head height
   // print ("subtracted baseheight of $baseHeight and head height of ${inventory.currentHead!.configurations.first.minHeight}");
    for (var i in inventory.requiredAKS) { // required AKS heights
      mountHeight -= i.configurations.first.minHeight;
     // print ("subtracted height of ${i.configurations.first.minHeight} for item ${i.name}");
    }

    // mountHeight now represents only support inventory (everything below the Mitchell mount)
    for (var i in inventory.coreSupports) {
      //print("evaluating ${i.name} for height $mountHeight");
      // get every configuration that is at or below mountHeight
      List<ComplexSupportConfiguration> configs = i.getConfigurationsForHeight(mountHeight);
      if (configs.isNotEmpty) {
        for (var j in configs) {
          _currentSolutions.add(makeSolutionModel(
            item: i,
            configuration: j)
          );
        }
      } else {
       // print("no valid configurations for ${i.name}");
      }
    }

    return _currentSolutions;
  }

  SolutionModel makeSolutionModel({required ComplexSupport item, required ComplexSupportConfiguration configuration}) {
    // Parameter 'item' is a configuration that is not already taller than mountHeight, so find the combination of groundAKS that will make it work

    List<SolutionModelItem> supportList = [SolutionModelItem(count: 1, item: item, configuration: configuration)];

    SolutionModel solutionModel = SolutionModel(items: supportList);

    if (configuration.isHeightWithinRange(mountHeight)) {
      // configuration is already good to go
      return solutionModel;
    } else {
      // need to add up groundAKS
      int workingHeight = mountHeight;
      workingHeight -= configuration.minHeight;
      for (var i in inventory.groundAKS) { // groundAKS must be in order from heaviest support to lightest (typically full applebox #3 to pancake)
       // print("ground item ${i.name} has ${i.configurations.length} configurations");
        for (var j in i.configurations) {
          int numberOf = (workingHeight / j.minHeight).floor(); // how many of this groundaks item will fit into the remaining height
         // print("using $numberOf of ${i.name} in configuration ${j.name} with minHeight ${j.minHeight}");
          if (numberOf > 0) solutionModel.items.add(SolutionModelItem(count: numberOf, item: i, configuration: j));
          workingHeight -= (j.minHeight * numberOf);
        }
      }
    }



    return solutionModel;
  }

  void removeAllSolutions() {
    _currentSolutions = [];
  }

}