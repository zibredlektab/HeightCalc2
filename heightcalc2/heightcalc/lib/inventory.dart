import 'package:heightcalc/data_types/data_types.dart';

class Inventory {
  // UserItems is used to keep track of all items that the user has added to the app, and access/modify those lists

  List<ComplexSupport> tripodHeads = []; // All lists start empty, but the user should be prompted to import defaults if so
  List<ComplexSupport> coreSupports = []; // Tripods, Hi hats, etc
  List<Dolly> dollys = []; // Core Support items that can go on track
  List<ComplexSupport> headAKS = []; // Items that stack above the Mitchell mount
  List<ComplexSupport> groundAKS = []; // Items that stack below the core support

  int baseHeight = 0; // height from camera base to mid-lens
  ComplexSupport? currentHead; // only one tripod head can be in use, and is typically selected creatively before the shot is set up
  List<ComplexSupport> requiredAKS = []; // AKS the user has selected creatively

  Inventory();

  void setBaseHeight(int newHeight) {
    baseHeight = newHeight;
  }

}