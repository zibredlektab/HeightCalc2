class ComplexSupportConfiguration {
  ComplexSupportConfiguration({
    this.name = "Default",
    required this.minHeight,
    required this.maxHeight,
    this.canStack = true,
    this.newConfig = false
  }) {
    checkAdjustable();
  }

  String name;
  int minHeight;
  int maxHeight;
  bool canStack = true;
  bool adjustableHeight = false;
  bool newConfig = false;

  void checkAdjustable() {
    if (minHeight == maxHeight) {
      adjustableHeight = false;
    } else {
      adjustableHeight = true;
    }
  }

  void updateHeight({
    required minHeightNew,
    required maxHeightNew
  }) {
    minHeight = minHeightNew;
    maxHeight = maxHeightNew;
    checkAdjustable();
  }

  bool canReachHeight(int testHeight) {
    // testHeight needs to be above minHeight, but it is okay if it is below maxHeight
    return testHeight >= minHeight ?  true : false;
  }

  bool isHeightWithinRange(int testHeight) {
    // is testHeight specifically within range
    return (testHeight >= minHeight && testHeight <= maxHeight) ? true : false;
  }

}