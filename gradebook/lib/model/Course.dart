class Course {

  final String title;
  final int credits;


  Course({this.title, this.credits});

  @override
  String toString() {
    return {title, credits}.toString();
  }

}
