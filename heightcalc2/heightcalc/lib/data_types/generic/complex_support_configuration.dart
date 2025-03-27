class ComplexSupportConfiguration {
  // TODO optionally specify a non-adjustable height instead of min & max
  ComplexSupportConfiguration({
    this.name = "",
    required this.minHeight,
    required this.maxHeight,
  });

  String name;
  int minHeight;
  int maxHeight;

  bool canReachHeight(int testHeight) {
    // testHeight needs to be above minHeight, but it is okay if it is below maxHeight
    return testHeight >= minHeight ?  true : false;
  }

  bool isHeightWithinRange(int testHeight) {
    // is testHeight specifically within range
    return (testHeight >= minHeight && testHeight <= maxHeight) ? true : false;
  }

}