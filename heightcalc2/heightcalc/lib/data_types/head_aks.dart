import 'package:heightcalc/data_types/aks.dart';

class HeadAKS extends AKS {
  bool _canUseBoxes = false;
  int _heightOnBoxes = -1;

  bool get canUseBoxes => _canUseBoxes;
  int get heightOnBoxes => _heightOnBoxes;

  HeadAKS(super._name, super._height, {bool canUseBoxes = false, int heightOnBoxes = -1}) {
    if (_canUseBoxes) {
      _canUseBoxes = canUseBoxes;
      if (heightOnBoxes > 0) {
        _heightOnBoxes = heightOnBoxes;
      } else {
        // todo error (object can use boxes, but doesn't have a defined box height)
      }
    }
  }
}