import 'dart:convert';

import 'package:hack_cal_app/model/event.dart';
import 'package:hack_cal_app/model/user.dart';

class AppState {
  static var empty = AppState(eventList: new List(), userList: new List());

  final List<Event> eventList;

  final List<User> userList;

  AppState({this.eventList, this.userList});

  factory AppState.fromJson(List<dynamic> events, List<dynamic> users) {
    List<Event> eventList = events
        .map((i) => new Event.fromJson(i as Map<String, dynamic>))
        .toList();
    List<User> userList =
        users.map((i) => new User.fromJson(i as Map<String, dynamic>)).toList();

    return AppState(eventList: eventList, userList: userList);
  }

  Map<String, dynamic> toJson() => {'events': eventList, 'user': userList};

  @override
  String toString() => json.encode(toJson());
}
