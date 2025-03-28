import 'package:heightcalc/data_types/generic/complex_support_configuration.dart';

class ComplexSupport {
  // Complex Supports have a list of configuration states (at least one), specifying min and max heights in each state
  
  String name;
  List<ComplexSupportConfiguration> configurations;
  
  ComplexSupport({
    required this.name,
    required this.configurations,
  });


  List<ComplexSupportConfiguration> getConfigurationsForHeight(int testHeight) {
    // returns a list of all configurations that are not taller than this height at their minimum

    List<ComplexSupportConfiguration> valid = [];
    for (var i in configurations) {
     // print("testing wether configuration '${i.name}' can reach height $testHeight");
      if (i.canReachHeight(testHeight)) valid.add(i);
    }

    return valid;
  }
}