class GradeBookUser {

  final String uid;
  final String email;
  final String photoUrl;
  String displayName;

  GradeBookUser({this.uid, this.email, this.photoUrl, this.displayName});

  @override
  String toString() {
    return {uid, email, photoUrl, displayName}.toString();
  }

}