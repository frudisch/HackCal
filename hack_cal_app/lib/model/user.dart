class User {
  final String uuid;
  final String name;

  User({this.uuid, this.name});

  int compareTo(User other) => name.compareTo(other.name);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uuid: json['uuid'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
      };

  @override
  String toString() {
    return name;
  }
}
