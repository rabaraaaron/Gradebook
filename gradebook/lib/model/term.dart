class Term {

  final String name;
  final int year;
  final List courses;


  Term({this.name, this.year, this.courses});

  @override
  String toString() {
    return {name, year, courses}.toString();
  }

}