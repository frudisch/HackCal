class User {
  final String uuid;
  final String username;
  final String firstName;
  final String lastName;

  User({this.uuid, this.username, this.firstName, this.lastName});

  int compareTo(User other) => username.compareTo(other.username);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        uuid: json['uuid'],
        username: json['username'],
        firstName: json['firstName'],
        lastName: json['lastName']);
  }

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'username': username,
        'firstName': firstName,
        'lastName': lastName
      };

  @override
  String toString() {
    return username;
  }
}
