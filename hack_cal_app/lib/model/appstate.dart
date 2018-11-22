import 'dart:convert';

import 'package:hack_cal_app/model/event.dart';
import 'package:hack_cal_app/model/user.dart';

class AppState {
  static var empty = AppState(eventList: new List(), userList: new List());

  final List<Event> eventList;
  final Map<String, List<String>> members;
  final List<User> userList;

  AppState({this.eventList, this.members, this.userList});

  factory AppState.fromJson(
      {List<dynamic> events,
      Map<String, List<String>> members,
      List<dynamic> user}) {
    List<Event> eventList = events == null
        ? []
        : events
            .map((i) => new Event.fromJson(i as Map<String, dynamic>))
            .toList();
    List<User> userList = user == null
        ? []
        : user
            .map((i) => new User.fromJson(i as Map<String, dynamic>))
            .toList();
    Map<String, List<String>> memberMap = members == null ? new Map() : members;

    return AppState(
        eventList: eventList, members: memberMap, userList: userList);
  }

  Map<String, dynamic> toJson() =>
      {'events': eventList, 'members': members, 'user': userList};

  List<User> fullMembers(String uuid) {
    List<String> member = members[uuid];
    if (member == null) {
      return [];
    }
    return member
        .map((uuid) => userList.firstWhere((u) => u.uuid == uuid,
            orElse: () => User(uuid: uuid, name: '<unbekannt:${uuid}>')))
        .toList();
  }

  @override
  String toString() => json.encode(toJson());
}
