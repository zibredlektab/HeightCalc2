class ComplexSupportConfiguration {
  // TODO optionally specify a non-adjustable height instead of min & max
  ComplexSupportConfiguration({
    required this.name,
    required this.minHeight,
    required this.maxHeight,
  });

  String name;
  int minHeight;
  int maxHeight;

  bool isHeightWithinRange(int testHeight) {
    if (testHeight >= minHeight && testHeight <= maxHeight) return true;
    return false;
  }

}