import 'package:heightcalc/data_types/data_types.dart';

class SolutionModel {

  // SolutionModel contains a list of items, in order from the ground up, which add up to the current desired height (minus baseheight)

  List<AKS> items;

  SolutionModel({this.items = const []});

  String getList() {
    String list = "";
    for (var i in items) {
      list += " ${i.name}";
    }
    return list;
  }

}