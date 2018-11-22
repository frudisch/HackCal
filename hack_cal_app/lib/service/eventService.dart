import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/event.dart';
import '../model/user.dart';

class EventService {
  final String EVENT_URL = 'http://localhost:5000/event';

  Future<List<Event>> getEvents() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    return [
      Event(
          uuid: 'uuid',
          name: 'name',
          date: DateTime(2018, 11, 21, 15, 59),
          description: 'Beschreibung'),
      Event(
          uuid: 'uuid2',
          name: 'name2',
          date: DateTime.now(),
          description: 'Andere Beschreibung'),
      Event(
          uuid: 'uuid21',
          name: 'name3',
          date: DateTime.now(),
          description: 'Andere Beschreibung'),
      Event(
          uuid: 'uuid3',
          name: 'name event',
          date: DateTime.now().add(Duration(days: 7)),
          description: 'Nochmal eine andere Beschreibung')
    ];

    final String url = EVENT_URL;
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body).map((i) => Event.fromJson(i)).toList();
    } else {
      throw Exception('Failed to load: GET ${url}');
    }
  }

  Future<Event> getEvent(String uuid) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    return Event(
        uuid: uuid,
        name: 'name',
        date: DateTime(2018, 11, 21, 15, 59),
        description: 'Beschreibung');

    final String url = EVENT_URL + '/' + uuid;
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Event.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load: GET ${url}');
    }
  }

  Future<List<User>> getTeilnehmerVonEvent(String uuid) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    return [User(name: 'Vorname Nachname'), User(name: 'Bester Freund')];

    final String url = EVENT_URL + '/' + uuid + '/teilnehmer';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body).map((i) => User.fromJson(i)).toList();
    } else {
      throw Exception('Failed to load: GET ${url}');
    }
  }

  addEvent(Event event) async {
    print('Received Event: ${event.toJson()}');
    await Future.delayed(const Duration(milliseconds: 2000));
    return;

    final String url = EVENT_URL;
    final response = await http.put(url, body: event.toJson());

    if (response.statusCode >= 300) {
      throw Exception('Failed to load: PUT ${url}');
    }
  }

  deleteEvent(Event event) async {
    print('Delete Event: ${event.toJson()}');
    await Future.delayed(const Duration(milliseconds: 2000));
    return;

    final String url = EVENT_URL + '/' + event.uuid;
    final response = await http.delete(url);

    if (response.statusCode >= 300) {
      throw Exception('Failed to load: DELETE ${url}');
    }
  }
}
