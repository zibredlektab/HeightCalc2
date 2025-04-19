import 'package:heightcalc/data_types/generic/complex_support_configuration.dart';

class ComplexSupport {
  // Complex Supports have a list of configuration states (at least one), specifying min and max heights in each state
  
  SupportType type;
  String name;
  List<ComplexSupportConfiguration> configurations;
  bool newItem;
  
  ComplexSupport({
    required this.type,
    required this.name,
    required this.configurations,
    this.newItem = false,
  });


  List<ComplexSupportConfiguration> getConfigurationsForHeight(int testHeight) {
    // returns a list of all configurations that are not taller than this height at their minimum

    List<ComplexSupportConfiguration> valid = [];
    for (var i in configurations) {
     // print("testing whether configuration '${i.name}' can reach height $testHeight");
      if (i.canReachHeight(testHeight)) valid.add(i);
    }

    return valid;
  }

  void addConfig({ComplexSupportConfiguration? newConfig}) {
    if (newConfig != null) {
      configurations.add(newConfig);
    } else {
      print ("Adding a new configuration to item $name");
      String newName = "New Config";
      var index = 0;
      while (!isConfigNameUnique(name: newName, newConfig: true)) {
        print ("Naming clash, trying the next name");
        newName = "New Config ${++index}";
      }
      print ("final config name is $newName");
      configurations.add(ComplexSupportConfiguration(name: newName, minHeight: 0, maxHeight: 0, newConfig: true));
    }
  }

  bool isConfigNameUnique({required String name, bool newConfig = false}) {
    bool foundMyself = false;
    for (var i in configurations) {
      print("checking config ${i.name} for match with \"$name\"");
      if (i.name == name) {
        print("${i.name} is a match");
        if (!newConfig && !foundMyself) {
          print ("This config already exists, and this match is itself. Skipping!");
          foundMyself = true;
        } else {
          return false;
        }
      }
    }
    return true;
  }
}

enum SupportType {
  tripodHead,
  headAKS,
  coreSupport,
  dolly,
  groundAKS,
}