class Assessment {

  final String name;
  final double totalPoints;
  final double yourPoints;
  final String id;
  final String parentID;


  Assessment({this.name, this.totalPoints, this.yourPoints, this.id, this.parentID});

  @override
  String toString() {
    return {name, totalPoints, yourPoints}.toString();
  }

}