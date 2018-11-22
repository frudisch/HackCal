class Event {
  final String uuid;
  final String name;
  final DateTime date;
  final String description;

  Event({this.uuid, this.name, this.date, this.description});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      uuid: json['uuid'],
      name: json['name'],
      date: DateTime.parse(json['date']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'date': date != null ? date.toIso8601String() : null,
        'description': description,
      };
}
