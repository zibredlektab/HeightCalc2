import 'package:heightcalc/data_types/data_types.dart';
import 'package:heightcalc/data_types/generic/complex_support_configuration.dart';

class SolutionModelItem {

  int count = 0; // How many of the item are used in this solution
  late ComplexSupport item; // What the item in question is
  late ComplexSupportConfiguration configuration; // What configuration the item is in

  SolutionModelItem({
    required this.count,
    required this.item,
    required this.configuration,
  });
}

class SolutionModel {

  // SolutionModel contains a list of items, in order from the ground up, which add up to the current desired height (minus baseheight)

  List<SolutionModelItem> items;

  SolutionModel({this.items = const []});

  String getList() {
    String list = "";
    for (var i in items) {
      if (i != items.first) list += " ";
      if ((i != items.first) && ((items.length < 2) || (items.length > 2 && i == items.last))) list += "and ";
      if (i.count > 1) {
        list += "${i.count}x ${i.item.name}";
      } else {
        list += "${i.item.name}";
      }

      if (i.item.configurations.length > 1) {
        list += " (${i.configuration.name})";
      }

      if (i != items.last) list += ",";
    }
    return list;
  }

}