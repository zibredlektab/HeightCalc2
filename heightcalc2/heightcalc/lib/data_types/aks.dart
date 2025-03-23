abstract class AKS {
  String _name;
  int _height;
  late List<AKS> worksWith;

  String get name => _name;
  int get height => _height;

  AKS(this._name, this._height, {worksWith}) {
    if (worksWith == null) {
      this.worksWith = [];
    } else {
      this.worksWith = worksWith;
    }
  }
}