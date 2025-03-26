import 'package:heightcalc/data_types/data_types.dart';
import 'package:heightcalc/solution_model.dart';
import 'package:heightcalc/user_items.dart';

class Calculator {
  UserItems items;
  int baseHeight = 0;
  int shotHeight = 0;
  int goalHeight = 0;
  List<SolutionModel> _currentSolutions = [];

  Calculator(this.items) {
    baseHeight = items.baseHeight;
  }

  List<SolutionModel> calculateHeight (int height) {
    /* subtract baseheight and current head height from shotheight
        then, subtract all required aks from shotheight
        the remaining value is the height we need to acheive
        cycle through the tripods, dollys, and generic support to find supports that are below the desired height
        then work out what aks are available to add onto these (rollers / appleboxes / risers)
        finally, build a solutionmodel for each valid solution, ordered by preference
    */
    removeAllSolutions();

    shotHeight = height;
    goalHeight = shotHeight - baseHeight; // camera height
    goalHeight -= items.currentHead!.height; // head height
    for (var i in items.requiredAKS) { // required AKS heights
      goalHeight -= i.height;
    }

    // goalHeight now represents only support items

    for (var i in items.complexSupports) { // support lists should always be ordered from shortest to tallest
      if (i.height > shotHeight) {
        break;
      } else {
        _currentSolutions.add(makeSolution(i));
      }
    }

    for (var i in items.genericSupports) { // support lists should always be ordered from shortest to tallest
      if (i.height > shotHeight) {
        break;
      } else {
        _currentSolutions.add(makeSolution(i));
      }
    }

    return _currentSolutions;
  }

  SolutionModel makeSolution(AKS item) {

    List<AKS> supportList = [item];

    SolutionModel solutionModel = SolutionModel(items: supportList);

    if (item.height == goalHeight) {
      return solutionModel;
    }

    if (item is ComplexSupport) {
      // check if rollers will get us there
      
    }

    return solutionModel;
  }

  void removeAllSolutions() {
    _currentSolutions = [];
  }

}