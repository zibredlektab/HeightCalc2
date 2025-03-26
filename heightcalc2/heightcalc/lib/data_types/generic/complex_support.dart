import 'package:heightcalc/data_types/generic/aks.dart';
import 'package:heightcalc/data_types/generic/complex_support_configuration.dart';

abstract class ComplexSupport extends AKS {
  // Complex Supports have a list of configuration states (at least one), specifying min and max heights in each state
  
  ComplexSupport({
    required super.name,
    required super.height,
    required this.configurations,
  });

  List<ComplexSupportConfiguration> configurations;


  List<ComplexSupportConfiguration> getConfigurationsForRange(int testHeight) {
    // returns a list of all configurations that cover this height

    List<ComplexSupportConfiguration> valid = [];
    for (var i in configurations) {
      if (i.isHeightWithinRange(testHeight)) valid.add(i);
    }

    return valid;
  }
}