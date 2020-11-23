class Term {

  final String name;
  final int year;
  final List courses;
  final double gpa;
  final String termID;


  Term({this.name, this.year, this.courses, this.gpa, this.termID});

  @override
  String toString() {
    return {name, year, courses, gpa, termID}.toString();
  }

}