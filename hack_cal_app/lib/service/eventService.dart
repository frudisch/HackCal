import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/event.dart';

class EventService {
  final String EVENT_URL = 'http://localhost:5000/event';

  Future<List<Event>> getEvents() async {
    return await [
      Event(
          uuid: 'uuid',
          name: 'name',
          date: DateTime(2018, 11, 21, 15, 59),
          description: 'Beschreibung'),
      Event(
          uuid: 'uuid2',
          name: 'name2',
          date: DateTime(2018, 11, 23, 17, 50),
          description: 'Andere Beschreibung')
    ];

    final String url = EVENT_URL;
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body).map((i) => Event.fromJson(i)).toList();
    } else {
      throw Exception('Failed to load: GET ' + url);
    }
  }

  Future<Event> getEvent(int id) async {
    return await Event(
        uuid: 'uuid',
        name: 'name',
        date: DateTime(2018, 11, 21, 15, 59),
        description: 'Beschreibung');

    final String url = EVENT_URL + '/' + id.toString();
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Event.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load: GET ' + url);
    }
  }
}
