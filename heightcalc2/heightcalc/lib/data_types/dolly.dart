import 'package:heightcalc/data_types/generic/complex_support.dart';

class Dolly extends ComplexSupport {
  Dolly({
    super.type = SupportType.dolly,
    required super.name,
    required super.configurations,
    this.hasTrack = false,
    this.trackHeight = 0,
  });
  
  bool hasTrack;
  int trackHeight;
}