class Term {

  final String name;
  final int year;
  final List courses;
  final double gpa;


  Term({this.name, this.year, this.courses, this.gpa});

  @override
  String toString() {
    return {name, year, courses, gpa}.toString();
  }

}