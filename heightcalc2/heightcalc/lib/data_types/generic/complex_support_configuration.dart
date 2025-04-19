import 'dart:math';

class ComplexSupportConfiguration {
  ComplexSupportConfiguration({
    this.name = "Default",
    required this.minHeight,
    required this.maxHeight,
    this.canStack = true,
    this.newConfig = false,
    this.adjustableHeight = true,
  }) {
    if (adjustableHeight = true) {
      // if the configuration supposedly has an adjustable height, double check that the heights are different 
      checkAdjustable();
      if (!adjustableHeight) {
        maxHeight = minHeight;
      }
    }
  }

  int id = Random().nextInt(0xFFFFFFFF); // some big number, probably big enough?
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
    required int minHeightNew,
    int maxHeightNew = 0,
  }) {
    minHeight = minHeightNew;
    if (maxHeightNew == 0) {
      maxHeight = minHeightNew;
      adjustableHeight = false;
    } else {
      maxHeight = maxHeightNew;
      checkAdjustable();
    }
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