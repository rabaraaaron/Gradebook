class Term {

  final String name;
  final int year;
  final List courses;
  final double gpa;
  final String termID;
  final double credits;


  Term({this.name, this.year, this.courses, this.gpa, this.termID, this.credits});

  @override
  String toString() {
    return {name, year, courses, gpa, credits, termID}.toString();
  }

}