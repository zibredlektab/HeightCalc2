import 'package:heightcalc/data_types/data_types.dart';

class UserItems {
  // UserItems is used to keep track of all items that the user has added to the app, and access/modify those lists

  List<TripodHead> tripodHeads = []; // All lists start empty, but the user should be prompted to import defaults if so
  List<ComplexSupport> coreSupports = []; // Tripods, Hi hats, etc
  List<Dolly> dollys = []; // Core Support items that can go on track
  List<HeadAKS> headAKS = []; // Items that stack above the Mitchell mount
  List<GroundAKS> groundAKS = []; // Items that stack below the core support

  int baseHeight = 0; // height from camera base to mid-lens
  TripodHead? currentHead; // only one tripod head can be in use, and is typically selected creatively before the shot is set up
  List<AKS> requiredAKS = []; // AKS the user has selected creatively

  UserItems();

}