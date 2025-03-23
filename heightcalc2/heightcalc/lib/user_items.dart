import 'package:heightcalc/data_types/core_support.dart';
import 'package:heightcalc/data_types/ground_aks.dart';
import 'package:heightcalc/data_types/head_aks.dart';
import 'package:heightcalc/data_types/tripod_head.dart';

class UserItems {
  // UserItems is used to keep track of all items that the user has added to the app, and access/modify those lists

  List<TripodHead> _tripodHeads = []; // All lists start empty, but the user should be prompted to import defaults if so
  List<HeadAKS> _headAKS = [];
  List<CoreSupport> _coreSupport = [];
  List<GroundAKS> _groundAKS = [];

  int baseHeight = 0;

  UserItems();

  List<TripodHead> get userTripodHeads => _tripodHeads;
  List<HeadAKS> get userHeadAKS => _headAKS;
  List<CoreSupport> get userCoreSupport => _coreSupport;
  List<GroundAKS> get userGroundAKS => _groundAKS;

}