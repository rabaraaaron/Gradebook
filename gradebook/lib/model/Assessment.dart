class Assessment {

  final String name;
  final String totalPoints;
  final String yourPoints;
  final String id;


  Assessment({this.name, this.totalPoints, this.yourPoints, this.id});

  @override
  String toString() {
    return {name, totalPoints, yourPoints}.toString();
  }

}