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
      {List<Event> events,
      Map<String, List<String>> members,
      List<User> user}) {
    List<Event> eventList = events == null ? [] : events;
    List<User> userList = user == null ? [] : user;
    Map<String, List<String>> memberMap = members == null ? new Map() : members;

    return AppState(
        eventList: eventList, members: memberMap, userList: userList);
  }

  Map<String, dynamic> toJson() =>
      {'events': eventList, 'members': members, 'user': userList};

  List<User> fullMembers(String uuid) {
    List<String> member = members != null ? members[uuid] : null;
    if (member == null) {
      return [];
    }
    return member
        .map((uuid) => userList.firstWhere((u) => u.uuid == uuid,
            orElse: () => User(uuid: uuid, username: '<unbekannt:$uuid>')))
        .toList();
  }

  @override
  String toString() => json.encode(toJson());
}
