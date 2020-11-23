class Assessment {

  final String name;
  final double totalPoints;
  final double yourPoints;
  final String id;


  Assessment({this.name, this.totalPoints, this.yourPoints, this.id});

  @override
  String toString() {
    return {name, totalPoints, yourPoints}.toString();
  }

}