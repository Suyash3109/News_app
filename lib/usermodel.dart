class usermodel {
  String? firstname;
  String? email;
  String? secondname;
  String? uid;

  usermodel({this.email, this.firstname, this.secondname, this.uid});

  factory usermodel.fromMap(map) {
    return usermodel(
        firstname: map['firstname'],
        secondname: map['secondname'],
        email: map['email'],
        uid: map['uid']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstname': firstname,
      'secondname': secondname,
      'email': email,
    };
  }
}
