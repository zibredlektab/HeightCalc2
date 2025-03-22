import 'package:heightcalc/imports.dart';

class AKS {
  String name = "";
  int height = 0;

  String getName() {
    return name;
  }

  void setName(String newName) {
    name = newName;
  }

  void setHeight(int newHeight) {
    height = newHeight;
  }
}

class TripodHead extends AKS {
  // Height is itchell to camera base, with no other accessories
  
  TripodHead(name, height) {
    super.name = name;
    super.height = height;
  }

}

class HeadAccessory extends AKS{
  // Head Accessories are any item that goes between the Mitchell mount and the camera, besides the head itself
  // This includes Fisher Rotating Offsets, risers, sliders, and Tango heads, for example
  // Height is height by which this accessory raises the camera when in use - not necessarily the same as total height of accessory
  bool? canUseBoxes = false; // sliders can be placed directly on apple boxes, for example
  int? heightOnBoxes = 0; // a slider on a box is a different height than on a tripod

  HeadAccessory(name, height, {this.canUseBoxes, this.heightOnBoxes}){
    super.name = name;
    super.height = height;
  }

}

class CoreSupport extends AKS {
  // Core Supports are the main supporting element of the camera setup, usually the item that the tripod head mounts to
  // Examples: tripods, dollys, hi-hats
  // Height is for non-adjustable core supports, the height from the bottom of this accessory to its Mitchell mount
  int? minHeight = 0; // lowest height for adjustable core supports (tripods which can raise/lower etc)
  int? maxHeight = 0; // highest etc

  CoreSupport(name, {height, this.minHeight, this.maxHeight}) {
    super.name = name;
    if (height != null && (minHeight == null || maxHeight == null)) {
      minHeight = height;
      maxHeight = height;
    }
    height ??= 0;
    super.height = height;
  }
}

class GroundSupport extends AKS {
  // Ground Supports are items that go underneath Core Supports.
  // Examples: apple boxes, rolling spreaders, dolly track

  List<String>? worksWith = []; // not all ground support is compatible with every core support (rollers don't work with dollys)

  GroundSupport(name, height, {this.worksWith}) {
    super.name = name;
    super.height = height;
  
    /*if (worksWith == null || worksWith?.length == 0) {
      // if worksWith is not provided, assume it works with everything
      worksWith = [];
      for (var i in coreSupports) {
        worksWith?.add(i.name);
      }
    }*/
  }
}