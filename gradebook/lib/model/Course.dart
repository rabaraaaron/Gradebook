class Course {

  final String name;
  final List categories;
  final double grade;
  final String credits;
  final String term;
  final int year;


  Course({this.name, this.categories, this.grade, this.term, this.year, this.credits});

  @override
  String toString() {
    return {name, year, categories, grade, term, credits}.toString();
  }

}

